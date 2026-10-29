// generate-test-inputs varre terraform/<scenario>/*/<resource>/variables.tf e gera,
// para cada diretorio, um arquivo de tfvars em test-data/generated-inputs/ com valores
// para as variaveis que o harness de pipeline (scripts/run-localstack-tests.sh) nao
// preenche automaticamente - sem alterar nenhum arquivo entregue em terraform/.
//
// Dois casos tratados:
//   - Variavel obrigatoria (sem default): recebe um valor generico por tipo/nome.
//   - Variavel com default que contem caractere fora do charset aceito pela AWS para
//     descricoes (ex.: "Saida HTTPS..."): recebe o mesmo valor, com os caracteres fora
//     do charset substituidos, preservando a estrutura original.
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

// Variaveis que o scripts/run-localstack-tests.sh ja preenche globalmente (via
// TF_VAR_*) de forma correta - incluindo nomes que precisam ser unicos por execucao
// (bucket_name, policy_name, role_name, security_group_name, name). Gerar um valor
// estatico para essas quebraria a unicidade entre execucoes.
var harnessManaged = map[string]bool{
	"bucket_name": true, "policy_name": true, "role_name": true,
	"security_group_name": true, "name": true,
	"environment": true, "system": true, "purpose": true, "bucket_purpose": true,
	"aws_region": true, "region": true,
	"enable_versioning": true, "versioning_enabled": true, "force_destroy": true,
	"tags": true, "additional_tags": true,
	"allowed_actions": true, "allowed_resources": true,
	"allowed_ports": true, "allowed_cidrs": true,
	"vpc_id": true,
}

var scenarios = []string{"manual", "ia-com-contexto", "ia-sem-contexto"}
var resources = []string{"s3", "iam", "security-group"}

// charset aceito pela AWS para description de regra de Security Group.
var awsDescriptionCharset = regexp.MustCompile(`^[0-9A-Za-z_ .:/()#,@\[\]+=&;{}!$*-]*$`)

var accentFold = map[rune]rune{
	'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a',
	'Á': 'A', 'À': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A',
	'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
	'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E',
	'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
	'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I',
	'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
	'Ó': 'O', 'Ò': 'O', 'Ô': 'O', 'Õ': 'O', 'Ö': 'O',
	'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
	'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U',
	'ç': 'c', 'Ç': 'C', 'ñ': 'n', 'Ñ': 'N',
}

func sanitizeForAWSCharset(s string) string {
	if awsDescriptionCharset.MatchString(s) {
		return s
	}

	var b strings.Builder

	for _, r := range s {
		if folded, ok := accentFold[r]; ok {
			b.WriteRune(folded)
			continue
		}

		if r < 128 && awsDescriptionCharset.MatchString(string(r)) {
			b.WriteRune(r)
			continue
		}

		b.WriteRune(' ')
	}

	return strings.Join(strings.Fields(b.String()), " ")
}

type variableBlock struct {
	name string
	body string
}

var variableHeaderRe = regexp.MustCompile(`variable\s+"([^"]+)"\s*{`)

func splitVariableBlocks(src string) []variableBlock {
	var blocks []variableBlock

	matches := variableHeaderRe.FindAllStringSubmatchIndex(src, -1)
	for _, m := range matches {
		name := src[m[2]:m[3]]
		bodyStart := m[1]

		end, ok := matchingBrace(src, bodyStart)
		if !ok {
			continue
		}

		blocks = append(blocks, variableBlock{name: name, body: src[bodyStart:end]})
	}

	return blocks
}

// matchingBrace recebe o indice logo apos o "{" de abertura (depth=1 implicito) e
// retorna o indice do "}" que fecha esse bloco, ignorando chaves dentro de strings.
func matchingBrace(src string, start int) (int, bool) {
	depth := 1
	inStr := false

	i := start
	for i < len(src) {
		c := src[i]

		if inStr {
			if c == '\\' {
				i += 2
				continue
			}

			if c == '"' {
				inStr = false
			}

			i++
			continue
		}

		switch c {
		case '"':
			inStr = true
		case '{':
			depth++
		case '}':
			depth--
			if depth == 0 {
				return i, true
			}
		}

		i++
	}

	return 0, false
}

// extractAttr extrai o texto bruto do valor de "key = <valor>" dentro de body,
// assumindo que body comeca imediatamente apos o "{" do bloco "variable ... {".
var blockHeaderRe = func(name string) *regexp.Regexp {
	return regexp.MustCompile(regexp.QuoteMeta(name) + `\s*{`)
}

// extractAllBlocks concatena o conteudo de todos os blocos "<blockName> { ... }"
// encontrados diretamente dentro de body (ex.: os (possiveis varios) blocos
// "validation" de uma variavel), para busca de padroes via regex.
func extractAllBlocks(body, blockName string) string {
	re := blockHeaderRe(blockName)

	var out strings.Builder

	matches := re.FindAllStringIndex(body, -1)
	for _, m := range matches {
		end, ok := matchingBrace(body, m[1])
		if !ok {
			continue
		}

		out.WriteString(body[m[1]:end])
		out.WriteString("\n")
	}

	return out.String()
}

// wrapForType envolve value em uma lista de um elemento quando o tipo
// declarado da variavel e list(...)/set(...) e value ainda nao e uma lista.
func wrapForType(value interface{}, typeExpr string) interface{} {
	t := strings.TrimSpace(typeExpr)
	if !strings.HasPrefix(t, "list(") && !strings.HasPrefix(t, "set(") {
		return value
	}

	if _, isList := value.([]interface{}); isList {
		return value
	}

	return []interface{}{value}
}

func extractAttr(body, key string) (string, bool) {
	re := regexp.MustCompile(`(?m)^[ \t]*` + regexp.QuoteMeta(key) + `[ \t]*=[ \t]*`)

	loc := re.FindStringIndex(body)
	if loc == nil {
		return "", false
	}

	start := loc[1]
	depth := 0
	inStr := false

	i := start
	for i < len(body) {
		c := body[i]

		if inStr {
			if c == '\\' {
				i += 2
				continue
			}

			if c == '"' {
				inStr = false
			}

			i++
			continue
		}

		switch c {
		case '"':
			inStr = true
		case '{', '[', '(':
			depth++
		case '}', ']', ')':
			if depth == 0 {
				return strings.TrimSpace(body[start:i]), true
			}

			depth--
		case '\n':
			if depth == 0 {
				return strings.TrimSpace(body[start:i]), true
			}
		}

		i++
	}

	return strings.TrimSpace(body[start:]), true
}

func containsNonASCII(s string) bool {
	for _, r := range s {
		if r > 127 {
			return true
		}
	}

	return false
}

// --- heuristica de valor generico para variaveis obrigatorias sem default ---

func guessScalar(name string) interface{} {
	lower := strings.ToLower(name)

	switch {
	case strings.Contains(lower, "ssh") && strings.Contains(lower, "cidr"):
		// Variaveis de CIDR de SSH costumam validar /32 e proibir 0.0.0.0/0.
		return "10.0.0.5/32"
	case strings.Contains(lower, "cidr"):
		return "10.0.0.0/16"
	case strings.Contains(lower, "arn") && (strings.Contains(lower, "principal") || strings.Contains(lower, "trusted")):
		return "arn:aws:iam::123456789012:role/tcc-pipeline-role"
	case strings.Contains(lower, "action"):
		return "s3:GetObject"
	case strings.Contains(lower, "resource") && !strings.Contains(lower, "resource_group"):
		return "arn:aws:s3:::tcc-experiment/*"
	case strings.Contains(lower, "service"):
		return "ec2.amazonaws.com"
	case strings.Contains(lower, "owner"):
		return "tcc-experimento@exemplo.com"
	case strings.Contains(lower, "description"):
		return "Valor gerado automaticamente para o pipeline de testes"
	case strings.Contains(lower, "email"):
		return "tcc-experimento@exemplo.com"
	case strings.Contains(lower, "port"):
		return 443
	default:
		return fmt.Sprintf("tcc-%s-generated", strings.ReplaceAll(lower, "_", "-"))
	}
}

// valueFromValidation tenta extrair, do texto de um bloco "validation", um
// valor que satisfaca condicoes simples e comuns nos templates do experimento:
//   - igualdade exata:      var.<name> == "literal"
//   - sufixo obrigatorio:   endswith(var.<name>, ".sufixo")
//   - igualdade por campo (para variaveis do tipo object): var.<name>.campo == "literal"
//
// Retorna (valor, true) quando alguma dessas formas e encontrada; (nil, false)
// caso contrario, para que o chamador caia no heuristico generico por nome/tipo.
func valueFromValidation(name, validationText string) (interface{}, bool) {
	if validationText == "" {
		return nil, false
	}

	escapedName := regexp.QuoteMeta(name)

	if m := regexp.MustCompile(`var\.` + escapedName + `\s*==\s*"([^"]*)"`).FindStringSubmatch(validationText); m != nil {
		return m[1], true
	}

	if m := regexp.MustCompile(`endswith\(\s*var\.` + escapedName + `\s*,\s*"([^"]*)"\s*\)`).FindStringSubmatch(validationText); m != nil {
		suffix := strings.TrimPrefix(m[1], ".")
		if suffix == "amazonaws.com" {
			return "ec2.amazonaws.com", true
		}

		return "valor-" + suffix, true
	}

	fieldMatches := regexp.MustCompile(`var\.` + escapedName + `\.(\w+)\s*==\s*"([^"]*)"`).FindAllStringSubmatch(validationText, -1)
	if len(fieldMatches) > 0 {
		obj := map[string]interface{}{}
		for _, fm := range fieldMatches {
			obj[fm[1]] = fm[2]
		}

		return obj, true
	}

	return nil, false
}

func guessValue(name, typeExpr string) interface{} {
	scalar := guessScalar(name)

	t := strings.TrimSpace(typeExpr)
	switch {
	case strings.HasPrefix(t, "bool"):
		return true
	case strings.HasPrefix(t, "number"):
		if n, ok := scalar.(int); ok {
			return n
		}

		return 1
	case strings.HasPrefix(t, "map("):
		return map[string]interface{}{}
	case strings.HasPrefix(t, "object("):
		return map[string]interface{}{}
	case strings.HasPrefix(t, "list(object") || strings.HasPrefix(t, "set(object"):
		// Estrutura complexa demais para sintetizar com seguranca - lista vazia e
		// o fallback mais neutro (a maioria dos usos trata ausencia de regras como
		// "nenhuma regra adicional", nao como erro).
		return []interface{}{}
	case strings.HasPrefix(t, "list(") || strings.HasPrefix(t, "set("):
		return []interface{}{scalar}
	default:
		return scalar
	}
}

// --- parser minimo de literais HCL (sem referencias/funcoes) para sanitizar
// defaults que contenham texto fora do charset aceito pela AWS ---

type literalParser struct {
	src string
	pos int
}

func parseHCLLiteral(src string) (interface{}, error) {
	p := &literalParser{src: src}
	p.skipSpace()

	v, err := p.parseValue()
	if err != nil {
		return nil, err
	}

	p.skipSpace()
	if p.pos != len(p.src) {
		return nil, fmt.Errorf("conteudo inesperado apos o literal em %d", p.pos)
	}

	return v, nil
}

func (p *literalParser) skipSpace() {
	for p.pos < len(p.src) {
		c := p.src[p.pos]
		if c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == ',' {
			p.pos++
			continue
		}

		break
	}
}

func (p *literalParser) parseValue() (interface{}, error) {
	p.skipSpace()
	if p.pos >= len(p.src) {
		return nil, fmt.Errorf("fim inesperado do literal")
	}

	switch p.src[p.pos] {
	case '"':
		return p.parseString()
	case '[':
		return p.parseList()
	case '{':
		return p.parseObject()
	}

	return p.parseKeyword()
}

func (p *literalParser) parseString() (string, error) {
	if p.src[p.pos] != '"' {
		return "", fmt.Errorf("string esperada em %d", p.pos)
	}

	p.pos++

	var b strings.Builder
	for p.pos < len(p.src) {
		c := p.src[p.pos]

		if c == '\\' && p.pos+1 < len(p.src) {
			next := p.src[p.pos+1]
			switch next {
			case 'n':
				b.WriteByte('\n')
			case 't':
				b.WriteByte('\t')
			default:
				b.WriteByte(next)
			}

			p.pos += 2
			continue
		}

		if c == '"' {
			p.pos++
			return b.String(), nil
		}

		b.WriteByte(c)
		p.pos++
	}

	return "", fmt.Errorf("string nao terminada")
}

func (p *literalParser) parseList() ([]interface{}, error) {
	p.pos++ // consome '['
	var items []interface{}

	for {
		p.skipSpace()
		if p.pos >= len(p.src) {
			return nil, fmt.Errorf("lista nao terminada")
		}

		if p.src[p.pos] == ']' {
			p.pos++
			return items, nil
		}

		v, err := p.parseValue()
		if err != nil {
			return nil, err
		}

		items = append(items, v)
		p.skipSpace()
	}
}

var identRe = regexp.MustCompile(`^[A-Za-z_][A-Za-z0-9_]*`)

func (p *literalParser) parseObject() (map[string]interface{}, error) {
	p.pos++ // consome '{'
	obj := map[string]interface{}{}

	for {
		p.skipSpace()
		if p.pos >= len(p.src) {
			return nil, fmt.Errorf("objeto nao terminado")
		}

		if p.src[p.pos] == '}' {
			p.pos++
			return obj, nil
		}

		var key string
		if p.src[p.pos] == '"' {
			k, err := p.parseString()
			if err != nil {
				return nil, err
			}

			key = k
		} else {
			m := identRe.FindString(p.src[p.pos:])
			if m == "" {
				return nil, fmt.Errorf("chave invalida em %d", p.pos)
			}

			key = m
			p.pos += len(m)
		}

		p.skipSpace()
		if p.pos >= len(p.src) || (p.src[p.pos] != '=' && p.src[p.pos] != ':') {
			return nil, fmt.Errorf("esperado '=' apos chave %q", key)
		}

		p.pos++
		p.skipSpace()

		v, err := p.parseValue()
		if err != nil {
			return nil, err
		}

		obj[key] = v
		p.skipSpace()
	}
}

var numberRe = regexp.MustCompile(`^-?[0-9]+(\.[0-9]+)?`)

func (p *literalParser) parseKeyword() (interface{}, error) {
	rest := p.src[p.pos:]

	switch {
	case strings.HasPrefix(rest, "true"):
		p.pos += 4
		return true, nil
	case strings.HasPrefix(rest, "false"):
		p.pos += 5
		return false, nil
	case strings.HasPrefix(rest, "null"):
		p.pos += 4
		return nil, nil
	}

	if m := numberRe.FindString(rest); m != "" {
		p.pos += len(m)

		n, err := strconv.ParseFloat(m, 64)
		if err != nil {
			return nil, err
		}

		return n, nil
	}

	return nil, fmt.Errorf("literal nao suportado em %d: %.20q", p.pos, rest)
}

func sanitizeLiteral(v interface{}) interface{} {
	switch val := v.(type) {
	case string:
		return sanitizeForAWSCharset(val)
	case []interface{}:
		out := make([]interface{}, len(val))
		for i, item := range val {
			out[i] = sanitizeLiteral(item)
		}

		return out
	case map[string]interface{}:
		out := map[string]interface{}{}
		for k, item := range val {
			out[k] = sanitizeLiteral(item)
		}

		return out
	default:
		return v
	}
}

// --- geracao por diretorio ---

// variableFilenames sao os nomes de arquivo onde templates do experimento
// declaram variaveis - "variable.tf" (singular) aparece por typo em pelo menos
// um template manual (p27/iam), e o parser precisa encontra-lo do mesmo jeito.
var variableFilenames = []string{"variables.tf", "variable.tf"}

// harnessOverridable sao nomes gerenciados pelo harness (ver harnessManaged)
// que, apesar disso, podem precisar de um valor diferente quando o proprio
// template valida um formato que o valor global fixo do harness nao satisfaz
// (ex.: trusted_principal_arn global e um ARN de conta-raiz, mas um template
// pode exigir um principal de servico "*.amazonaws.com").
var harnessOverridable = map[string]bool{
	"trusted_principal_arn": true, "trusted_principal_arns": true,
}

func processDirectory(scenario, resource, dir string) (map[string]interface{}, []string) {
	var src string

	for _, filename := range variableFilenames {
		data, err := os.ReadFile(filepath.Join(dir, filename))
		if err == nil {
			src = string(data)
			break
		}
	}

	if src == "" {
		return nil, nil
	}

	overrides := map[string]interface{}{}
	var notes []string

	for _, v := range splitVariableBlocks(src) {
		validationText := extractAllBlocks(v.body, "validation")
		typeRaw, _ := extractAttr(v.body, "type")
		defaultRaw, hasDefault := extractAttr(v.body, "default")

		// Alguns nomes sao gerenciados pelo harness globalmente (ver harnessManaged),
		// mas o valor fixo que ele exporta pode nao satisfazer a validacao propria
		// do template (ex.: trusted_principal_arn global e um ARN de conta-raiz, mas
		// o template pode exigir um principal de servico "*.amazonaws.com"). Nesses
		// casos, tenta reescrever a partir da propria validacao antes de decidir se
		// o nome deve ser pulado.
		if harnessOverridable[v.name] && validationText != "" {
			if value, ok := valueFromValidation(v.name, validationText); ok {
				overrides[v.name] = wrapForType(value, typeRaw)
				continue
			}
		}

		if harnessManaged[v.name] {
			continue
		}

		if !hasDefault {
			if value, ok := valueFromValidation(v.name, validationText); ok {
				overrides[v.name] = wrapForType(value, typeRaw)
				continue
			}

			overrides[v.name] = guessValue(v.name, typeRaw)
			continue
		}

		if !containsNonASCII(defaultRaw) {
			continue
		}

		parsed, err := parseHCLLiteral(defaultRaw)
		if err != nil {
			notes = append(notes, fmt.Sprintf(
				"%s: default de %q contem caractere fora do charset da AWS, mas nao foi possivel reescrever automaticamente (%v)",
				dir, v.name, err,
			))

			continue
		}

		overrides[v.name] = sanitizeLiteral(parsed)
	}

	return overrides, notes
}

func main() {
	root := flag.String("root", ".", "Raiz do repositorio")
	outDir := flag.String("out", "test-data/generated-inputs", "Diretorio de saida dos tfvars gerados")
	flag.Parse()

	generated := 0
	skippedEmpty := 0
	var allNotes []string

	for _, scenario := range scenarios {
		for _, resource := range resources {
			base := filepath.Join(*root, "terraform", scenario)

			entries, err := os.ReadDir(base)
			if err != nil {
				continue
			}

			var subjects []string
			for _, e := range entries {
				if e.IsDir() {
					subjects = append(subjects, e.Name())
				}
			}

			sort.Strings(subjects)

			for _, subject := range subjects {
				dir := filepath.Join(base, subject, resource)

				hasVariablesFile := false
				for _, filename := range variableFilenames {
					if _, err := os.Stat(filepath.Join(dir, filename)); err == nil {
						hasVariablesFile = true
						break
					}
				}

				if !hasVariablesFile {
					continue
				}

				overrides, notes := processDirectory(scenario, resource, dir)
				allNotes = append(allNotes, notes...)

				if len(overrides) == 0 {
					skippedEmpty++
					continue
				}

				outPath := filepath.Join(*root, *outDir, scenario, resource, subject+".auto.tfvars.json")

				if err := os.MkdirAll(filepath.Dir(outPath), 0o755); err != nil {
					fmt.Fprintf(os.Stderr, "erro ao criar diretorio para %s: %v\n", outPath, err)
					os.Exit(1)
				}

				encoded, err := json.MarshalIndent(overrides, "", "  ")
				if err != nil {
					fmt.Fprintf(os.Stderr, "erro ao codificar %s: %v\n", outPath, err)
					os.Exit(1)
				}

				if err := os.WriteFile(outPath, append(encoded, '\n'), 0o644); err != nil {
					fmt.Fprintf(os.Stderr, "erro ao escrever %s: %v\n", outPath, err)
					os.Exit(1)
				}

				fmt.Printf("gerado: %s (%d variavel(is))\n", outPath, len(overrides))
				generated++
			}
		}
	}

	fmt.Printf("\n%d arquivo(s) gerado(s), %d diretorio(s) sem lacunas detectadas.\n", generated, skippedEmpty)

	if len(allNotes) > 0 {
		fmt.Println("\nAvisos:")
		for _, n := range allNotes {
			fmt.Println(" - " + n)
		}
	}
}
