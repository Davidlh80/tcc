package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"syscall"
	"time"
)

const (
	claudeCallTimeout = 150 * time.Second
	claudeMaxAttempts = 3
	claudeRetryDelay  = 10 * time.Second
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
	resource := flag.String("resource", "", "Recurso: s3, iam, security-group ou vazio para os tres")
	model := flag.String("model", "sonnet", "Modelo Claude usado na geracao (alias como 'sonnet'/'opus' ou nome completo)")
	executionID := flag.String("execution-id", "", "Execucao especifica no formato exec-01")
	executionCount := flag.Int("execution-count", 30, "Numero de execucoes independentes a gerar")
	startExecution := flag.Int("start-execution", 1, "Primeira execucao a gerar")
	concurrency := flag.Int("concurrency", 6, "Numero de chamadas ao Claude CLI em paralelo")
	flag.Parse()

	resources := parseResources(*resource)

	if *executionID != "" {
		if err := generateBlueprint(*scenario, resources[0], *model, *executionID); err != nil {
			fmt.Fprintf(os.Stderr, "erro: %v\n", err)
			os.Exit(1)
		}
		return
	}

	if *executionCount <= 0 {
		fmt.Fprintf(os.Stderr, "erro: execution-count deve ser maior que zero\n")
		os.Exit(1)
	}

	if err := generateScenarioExecutions(*scenario, resources, *model, *startExecution, *executionCount, *concurrency); err != nil {
		fmt.Fprintf(os.Stderr, "erro: %v\n", err)
		os.Exit(1)
	}
}

func parseResources(raw string) []string {
	if strings.TrimSpace(raw) == "" {
		return []string{"s3", "iam", "security-group"}
	}

	parts := strings.Split(raw, ",")
	resources := make([]string, 0, len(parts))
	for _, part := range parts {
		resource := strings.TrimSpace(part)
		if resource == "" {
			continue
		}
		resources = append(resources, resource)
	}

	if len(resources) == 0 {
		return []string{"s3", "iam", "security-group"}
	}

	return resources
}

type generationTask struct {
	executionID string
	resource    string
}

func generateScenarioExecutions(scenario string, resources []string, model string, startExecution, executionCount, concurrency int) error {
	var tasks []generationTask

	for i := 0; i < executionCount; i++ {
		executionID := fmt.Sprintf("exec-%02d", startExecution+i)
		for _, resource := range resources {
			tasks = append(tasks, generationTask{executionID: executionID, resource: resource})
		}
	}

	if concurrency < 1 {
		concurrency = 1
	}
	if concurrency > len(tasks) {
		concurrency = len(tasks)
	}

	taskCh := make(chan generationTask)

	var (
		wg       sync.WaitGroup
		mu       sync.Mutex
		failures int
	)

	for w := 0; w < concurrency; w++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for t := range taskCh {
				if err := generateBlueprint(scenario, t.resource, model, t.executionID); err != nil {
					mu.Lock()
					failures++
					mu.Unlock()
					fmt.Fprintf(os.Stderr, "falha registrada em %s/%s/%s: %v\n", scenario, t.executionID, t.resource, err)
				}
			}
		}()
	}

	for _, t := range tasks {
		taskCh <- t
	}
	close(taskCh)

	wg.Wait()

	if failures > 0 {
		return fmt.Errorf("%d execucao(oes) falharam nesta rodada", failures)
	}

	return nil
}

func generateBlueprint(scenario, resource, model, executionID string) error {
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

	if executionID == "" {
		executionID = "exec-01"
	}

	promptPath := filepath.Join(projectRoot, "prompts", scenario, fmt.Sprintf("prompt-%s.md", resource))
	fmt.Printf("Prompt utilizado: %s\n", promptPath)

	basePrompt, err := readTextFile(promptPath)
	if err != nil {
		return err
	}

	var contextBlock string
	var contextPath string

	if scenario == "ia-com-contexto" {
		contextPath = filepath.Join(projectRoot, "contexto", "contexto-organizacional.md")
		fmt.Printf("Contexto utilizado: %s\n", contextPath)

		contextText, err := readTextFile(contextPath)
		if err != nil {
			return err
		}

		contextBlock = fmt.Sprintf("\nContexto organizacional:\n\n%s\n", contextText)
	}

	finalPrompt := buildPrompt(basePrompt, contextBlock)

	totalStartedAt := time.Now()
	apiStartedAt := time.Now()
	generated, err := callClaude(model, finalPrompt)
	apiFinishedAt := time.Now()
	if err != nil {
		return err
	}

	outputDir := filepath.Join(projectRoot, "terraform", scenario, executionID, resource)

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

	metadataPath := filepath.Join(outputDir, "metadata.yml")
	totalFinishedAt := time.Now()
	metadata := buildMetadata(
		scenario,
		executionID,
		resource,
		model,
		promptPath,
		contextPath,
		projectRoot,
		apiStartedAt,
		apiFinishedAt,
		totalStartedAt,
		totalFinishedAt,
	)
	if err := os.WriteFile(metadataPath, []byte(metadata), 0644); err != nil {
		return fmt.Errorf("falha ao escrever %s: %w", metadataPath, err)
	}
	fmt.Printf("Metadata gerado: %s\n", metadataPath)

	fmt.Printf("Blueprint gerada em: %s\n", outputDir)

	return nil
}

func callClaude(model, finalPrompt string) (string, error) {
	var lastErr error

	for attempt := 1; attempt <= claudeMaxAttempts; attempt++ {
		output, err := callClaudeOnce(model, finalPrompt)
		if err == nil {
			return output, nil
		}

		lastErr = err
		fmt.Fprintf(os.Stderr, "tentativa %d/%d falhou: %v\n", attempt, claudeMaxAttempts, err)

		if attempt < claudeMaxAttempts {
			time.Sleep(claudeRetryDelay)
		}
	}

	return "", lastErr
}

func callClaudeOnce(model, finalPrompt string) (string, error) {
	ctx, cancel := context.WithTimeout(context.Background(), claudeCallTimeout)
	defer cancel()

	cmd := exec.CommandContext(
		ctx,
		"claude",
		"-p",
		"--model", model,
		"--output-format", "text",
		"--disallowedTools", "Write,Edit,Bash,NotebookEdit,Read,Glob,Grep,WebFetch,WebSearch",
	)
	cmd.Stdin = strings.NewReader(finalPrompt)

	// claude -p pode gerar processos filhos proprios (subagentes, MCP servers,
	// etc). Sem isolar num process group e matar o grupo inteiro no timeout,
	// matar so o processo direto deixa um filho vivo segurando o pipe de
	// stdout aberto, e cmd.Output() trava para sempre esperando EOF.
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	cmd.Cancel = func() error {
		return syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL)
	}
	cmd.WaitDelay = 5 * time.Second

	var stderr strings.Builder
	cmd.Stderr = &stderr

	output, err := cmd.Output()
	if err != nil {
		if ctx.Err() == context.DeadlineExceeded {
			return "", fmt.Errorf("timeout de %s ao chamar Claude Code CLI", claudeCallTimeout)
		}
		return "", fmt.Errorf("falha ao chamar Claude Code CLI: %w (stderr: %s)", err, stderr.String())
	}

	return string(output), nil
}

func buildMetadata(
	scenario, executionID, resource, model, promptPath, contextPath, projectRoot string,
	apiStartedAt, apiFinishedAt, totalStartedAt, totalFinishedAt time.Time,
) string {
	promptRel, err := filepath.Rel(projectRoot, promptPath)
	if err != nil {
		promptRel = promptPath
	}

	contextRel := ""
	if contextPath != "" {
		if rel, err := filepath.Rel(projectRoot, contextPath); err == nil {
			contextRel = rel
		}
	}

	metadata := fmt.Sprintf("scenario: %s\nexecution_id: %s\nresource: %s\nmodel: %q\nprompt_file: %q\n",
		scenario,
		executionID,
		resource,
		model,
		filepath.ToSlash(promptRel),
	)

	if contextRel != "" {
		metadata += fmt.Sprintf("context_file: %q\n", filepath.ToSlash(contextRel))
	}

	metadata += fmt.Sprintf("started_at: %q\nfinished_at: %q\napi_duration_ms: %d\ntotal_duration_ms: %d\ngenerated_at: %q\ngeneration_tool: %q\n",
		totalStartedAt.Format(time.RFC3339Nano),
		totalFinishedAt.Format(time.RFC3339Nano),
		apiFinishedAt.Sub(apiStartedAt).Milliseconds(),
		totalFinishedAt.Sub(totalStartedAt).Milliseconds(),
		totalFinishedAt.Format(time.RFC3339Nano),
		"scripts/generate-blueprint",
	)

	return metadata
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
- Inclua outputs relevantes.
- Priorize configuracoes seguras por padrao.
- Antes de usar qualquer funcao nativa do Terraform (string, validacao, colecao, etc.), confira a assinatura oficial dela (quantidade e tipo de parametros) na documentacao da linguagem Terraform. Nao presuma o comportamento de funcoes de outras linguagens de programacao.
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
