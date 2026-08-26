package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/openai/openai-go/v3"
	"github.com/openai/openai-go/v3/responses"
)

var expectedFiles = []string{
	"main.tf",
	"variables.tf",
	"outputs.tf",
	"versions.tf",
	"README.md",
}

func main() {
	scenario := flag.String("scenario", "ia-com-contexto", "Cenario: ia-com-contexto ou ia-sem-contexto")
	resource := flag.String("resource", "s3", "Recurso: s3, iam ou security-group")
	model := flag.String("model", "gpt-5", "Modelo OpenAI usado na geracao")
	flag.Parse()

	if err := generateBlueprint(*scenario, *resource, *model); err != nil {
		fmt.Fprintf(os.Stderr, "erro: %v\n", err)
		os.Exit(1)
	}
}

func generateBlueprint(scenario, resource, model string) error {
	if scenario != "ia-com-contexto" && scenario != "ia-sem-contexto" {
		return fmt.Errorf("cenario invalido: %s", scenario)
	}

	if resource != "s3" && resource != "iam" && resource != "security-group" {
		return fmt.Errorf("recurso invalido: %s", resource)
	}

	projectRoot, err := findProjectRoot()
	if err != nil {
		return err
	}

	promptPath := filepath.Join(projectRoot, "prompts", scenario, fmt.Sprintf("prompt-%s.md", resource))
	fmt.Printf("Prompt utilizado: %s\n", promptPath)

	basePrompt, err := readTextFile(promptPath)
	if err != nil {
		return err
	}

	var contextBlock string

	if scenario == "ia-com-contexto" {
		contextPath := filepath.Join(projectRoot, "contexto", "contexto-organizacional.md")
		fmt.Printf("Contexto utilizado: %s\n", contextPath)

		contextText, err := readTextFile(contextPath)
		if err != nil {
			return err
		}

		contextBlock = fmt.Sprintf("\nContexto organizacional:\n\n%s\n", contextText)
	}

	finalPrompt := buildPrompt(basePrompt, contextBlock)

	client := openai.NewClient()
	ctx := context.Background()

	response, err := client.Responses.New(ctx, responses.ResponseNewParams{
		Model: openai.ChatModel(model),
		Input: responses.ResponseNewParamsInputUnion{
			OfString: openai.String(finalPrompt),
		},
	})
	if err != nil {
		return fmt.Errorf("falha ao chamar API da OpenAI: %w", err)
	}

	generated := response.OutputText()

	outputDir := filepath.Join(projectRoot, "terraform", scenario, resource)

	if err := os.MkdirAll(outputDir, 0755); err != nil {
		return fmt.Errorf("falha ao criar diretorio de saida: %w", err)
	}

	for _, filename := range expectedFiles {
		fileContent, err := extractFile(generated, filename)
		if err != nil {
			debugPath := filepath.Join(outputDir, "debug-response.txt")
			_ = os.WriteFile(debugPath, []byte(generated), 0644)
			return fmt.Errorf("%w. Resposta completa salva em %s", err, debugPath)
		}

		outputPath := filepath.Join(outputDir, filename)

		if err := os.WriteFile(outputPath, []byte(fileContent), 0644); err != nil {
			return fmt.Errorf("falha ao escrever %s: %w", outputPath, err)
		}

		fmt.Printf("Arquivo gerado: %s\n", outputPath)
	}

	fmt.Printf("Blueprint gerada em: %s\n", outputDir)

	return nil
}

func findProjectRoot() (string, error) {
	currentDir, err := os.Getwd()
	if err != nil {
		return "", fmt.Errorf("falha ao obter diretorio atual: %w", err)
	}

	for {
		if _, err := os.Stat(filepath.Join(currentDir, "go.mod")); err == nil {
			return currentDir, nil
		}

		parentDir := filepath.Dir(currentDir)
		if parentDir == currentDir {
			return "", fmt.Errorf("nao foi possivel localizar a raiz do projeto (go.mod)")
		}

		currentDir = parentDir
	}
}

func readTextFile(path string) (string, error) {
	content, err := os.ReadFile(path)
	if err != nil {
		return "", fmt.Errorf("falha ao ler %s: %w", path, err)
	}

	return string(content), nil
}

func buildPrompt(basePrompt, contextBlock string) string {
	return strings.TrimSpace(fmt.Sprintf(`
Voce e um especialista em Terraform, AWS, DevOps e seguranca de Infraestrutura como Codigo.

Gere uma blueprint Terraform completa para o recurso solicitado.

Arquivos obrigatorios:

- main.tf
- variables.tf
- outputs.tf
- versions.tf
- README.md

Regras de resposta:

- Retorne somente o conteudo dos arquivos.
- Nao escreva explicacoes fora dos arquivos.
- Nao use markdown code fences.
- Use exatamente estes marcadores:

--- main.tf ---
--- end main.tf ---

--- variables.tf ---
--- end variables.tf ---

--- outputs.tf ---
--- end outputs.tf ---

--- versions.tf ---
--- end versions.tf ---

--- README.md ---
--- end README.md ---

Regras tecnicas:

- O codigo deve ser compativel com Terraform.
- O provider deve ser AWS.
- Evite valores sensiveis fixos.
- Use variaveis para valores configuraveis.
- Inclua validacoes de variaveis quando fizer sentido.
- Inclua outputs relevantes.
- Priorize configuracoes seguras por padrao.
- Mantenha o codigo simples o suficiente para ser validado com terraform init -backend=false e terraform validate.
- Nao use backend remoto.
- Nao use valores que dependam de credenciais reais.
- Nao inclua arquivos alem dos cinco solicitados.

Prompt do experimento:

%s

%s
`, basePrompt, contextBlock))
}

func extractFile(content, filename string) (string, error) {
	startMarker := fmt.Sprintf("--- %s ---", filename)
	endMarker := fmt.Sprintf("--- end %s ---", filename)

	startIndex := strings.Index(content, startMarker)
	endIndex := strings.Index(content, endMarker)

	if startIndex == -1 || endIndex == -1 {
		return "", fmt.Errorf("marcadores nao encontrados para %s", filename)
	}

	startIndex += len(startMarker)

	if endIndex <= startIndex {
		return "", fmt.Errorf("conteudo vazio para %s", filename)
	}

	fileContent := strings.TrimSpace(content[startIndex:endIndex])

	return fileContent + "\n", nil
}
