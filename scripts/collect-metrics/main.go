package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"time"
)

type RunMetrics struct {
	CollectedAt        string           `json:"collected_at"`
	Repository         string           `json:"repository"`
	Workflow           string           `json:"workflow"`
	Job                string           `json:"job"`
	RunID              string           `json:"run_id"`
	RunAttempt         string           `json:"run_attempt"`
	EventName          string           `json:"event_name"`
	Ref                string           `json:"ref"`
	CommitSHA          string           `json:"commit_sha"`
	HeadRef            string           `json:"head_ref"`
	BaseRef            string           `json:"base_ref"`
	PullRequest        *PullRequestInfo `json:"pull_request,omitempty"`
	Templates          []TemplateInfo   `json:"templates"`
	TemplateCount      int              `json:"template_count"`
	TerraformFileCount int              `json:"terraform_file_count"`
}

type PullRequestInfo struct {
	Number          int     `json:"number"`
	Title           string  `json:"title"`
	State           string  `json:"state"`
	Author          string  `json:"author"`
	CreatedAt       string  `json:"created_at"`
	UpdatedAt       string  `json:"updated_at"`
	ClosedAt        string  `json:"closed_at,omitempty"`
	MergedAt        string  `json:"merged_at,omitempty"`
	HeadRef         string  `json:"head_ref"`
	BaseRef         string  `json:"base_ref"`
	LeadTimeMinutes float64 `json:"lead_time_minutes,omitempty"`
	TimeOpenMinutes float64 `json:"time_open_minutes,omitempty"`
	IsMerged        bool    `json:"is_merged"`
}

type TemplateInfo struct {
	Path        string `json:"path"`
	Scenario    string `json:"scenario"`
	SubjectID   string `json:"subject_id"`
	Resource    string `json:"resource"`
	MainTF      bool   `json:"has_main_tf"`
	VariablesTF bool   `json:"has_variables_tf"`
	OutputsTF   bool   `json:"has_outputs_tf"`
	VersionsTF  bool   `json:"has_versions_tf"`
	Readme      bool   `json:"has_readme"`
	Metadata    bool   `json:"has_metadata"`
	TFFileCount int    `json:"tf_file_count"`
}

func main() {
	projectRoot, err := findProjectRoot()
	if err != nil {
		fail(err)
	}

	outputDir := filepath.Join(projectRoot, "resultados", "metrics")
	if err := os.MkdirAll(outputDir, 0755); err != nil {
		fail(fmt.Errorf("falha ao criar diretorio de metricas: %w", err))
	}

	templates, tfFileCount, err := collectTemplateInventory(filepath.Join(projectRoot, "terraform"))
	if err != nil {
		fail(err)
	}

	metrics := RunMetrics{
		CollectedAt:        time.Now().Format(time.RFC3339),
		Repository:         os.Getenv("GITHUB_REPOSITORY"),
		Workflow:           os.Getenv("GITHUB_WORKFLOW"),
		Job:                os.Getenv("GITHUB_JOB"),
		RunID:              os.Getenv("GITHUB_RUN_ID"),
		RunAttempt:         os.Getenv("GITHUB_RUN_ATTEMPT"),
		EventName:          os.Getenv("GITHUB_EVENT_NAME"),
		Ref:                os.Getenv("GITHUB_REF"),
		CommitSHA:          os.Getenv("GITHUB_SHA"),
		HeadRef:            os.Getenv("GITHUB_HEAD_REF"),
		BaseRef:            os.Getenv("GITHUB_BASE_REF"),
		Templates:          templates,
		TemplateCount:      len(templates),
		TerraformFileCount: tfFileCount,
	}

	prInfo, err := parsePullRequestEvent(os.Getenv("GITHUB_EVENT_PATH"))
	if err != nil {
		fmt.Fprintf(os.Stderr, "aviso: nao foi possivel ler dados de PR: %v\n", err)
	} else {
		metrics.PullRequest = prInfo
	}

	if err := writeJSON(filepath.Join(outputDir, "run-metrics.json"), metrics); err != nil {
		fail(err)
	}

	if err := writeRunMetricsCSV(filepath.Join(outputDir, "run-metrics.csv"), metrics); err != nil {
		fail(err)
	}

	if err := writeTemplateInventoryCSV(filepath.Join(outputDir, "template-inventory.csv"), templates); err != nil {
		fail(err)
	}

	fmt.Printf("Metricas coletadas em: %s\n", outputDir)
	fmt.Printf("Templates encontrados: %d\n", len(templates))
	fmt.Printf("Arquivos .tf encontrados: %d\n", tfFileCount)
}

func collectTemplateInventory(terraformRoot string) ([]TemplateInfo, int, error) {
	if _, err := os.Stat(terraformRoot); err != nil {
		return nil, 0, fmt.Errorf("diretorio terraform nao encontrado: %s", terraformRoot)
	}

	dirs := map[string]int{}
	tfFileCount := 0

	err := filepath.WalkDir(terraformRoot, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			name := d.Name()
			if name == ".terraform" {
				return filepath.SkipDir
			}
			return nil
		}
		if strings.HasSuffix(d.Name(), ".tf") {
			tfFileCount++
			dirs[filepath.Dir(path)]++
		}
		return nil
	})
	if err != nil {
		return nil, 0, fmt.Errorf("falha ao percorrer terraform: %w", err)
	}

	templates := make([]TemplateInfo, 0, len(dirs))
	for dir, count := range dirs {
		rel, err := filepath.Rel(terraformRoot, dir)
		if err != nil {
			rel = dir
		}

		parts := splitPath(rel)
		info := TemplateInfo{
			Path:        filepath.ToSlash(filepath.Join("terraform", rel)),
			TFFileCount: count,
			MainTF:      fileExists(filepath.Join(dir, "main.tf")),
			VariablesTF: fileExists(filepath.Join(dir, "variables.tf")),
			OutputsTF:   fileExists(filepath.Join(dir, "outputs.tf")),
			VersionsTF:  fileExists(filepath.Join(dir, "versions.tf")),
			Readme:      fileExists(filepath.Join(dir, "README.md")),
			Metadata:    fileExists(filepath.Join(dir, "metadata.yml")),
		}

		if len(parts) >= 3 {
			info.Scenario = parts[0]
			info.SubjectID = parts[1]
			info.Resource = parts[2]
		}

		templates = append(templates, info)
	}

	sort.Slice(templates, func(i, j int) bool {
		return templates[i].Path < templates[j].Path
	})

	return templates, tfFileCount, nil
}

func parsePullRequestEvent(eventPath string) (*PullRequestInfo, error) {
	if strings.TrimSpace(eventPath) == "" {
		return nil, fmt.Errorf("GITHUB_EVENT_PATH vazio")
	}

	content, err := os.ReadFile(eventPath)
	if err != nil {
		return nil, err
	}

	var payload map[string]any
	if err := json.Unmarshal(content, &payload); err != nil {
		return nil, err
	}

	prRaw, ok := payload["pull_request"].(map[string]any)
	if !ok {
		return nil, fmt.Errorf("evento nao contem pull_request")
	}

	info := &PullRequestInfo{
		Number:    intFromAny(prRaw["number"]),
		Title:     stringFromAny(prRaw["title"]),
		State:     stringFromAny(prRaw["state"]),
		CreatedAt: stringFromAny(prRaw["created_at"]),
		UpdatedAt: stringFromAny(prRaw["updated_at"]),
		ClosedAt:  stringFromAny(prRaw["closed_at"]),
		MergedAt:  stringFromAny(prRaw["merged_at"]),
		IsMerged:  boolFromAny(prRaw["merged"]),
	}

	if user, ok := prRaw["user"].(map[string]any); ok {
		info.Author = stringFromAny(user["login"])
	}
	if head, ok := prRaw["head"].(map[string]any); ok {
		info.HeadRef = stringFromAny(head["ref"])
	}
	if base, ok := prRaw["base"].(map[string]any); ok {
		info.BaseRef = stringFromAny(base["ref"])
	}

	createdAt, err := time.Parse(time.RFC3339, info.CreatedAt)
	if err == nil {
		if info.MergedAt != "" {
			if mergedAt, err := time.Parse(time.RFC3339, info.MergedAt); err == nil {
				info.LeadTimeMinutes = mergedAt.Sub(createdAt).Minutes()
			}
		}
		if info.ClosedAt == "" {
			info.TimeOpenMinutes = time.Since(createdAt).Minutes()
		}
	}

	return info, nil
}

func writeJSON(path string, value any) error {
	content, err := json.MarshalIndent(value, "", "  ")
	if err != nil {
		return fmt.Errorf("falha ao serializar json: %w", err)
	}
	return os.WriteFile(path, append(content, '\n'), 0644)
}

func writeRunMetricsCSV(path string, metrics RunMetrics) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	_ = writer.Write([]string{
		"collected_at",
		"repository",
		"workflow",
		"job",
		"run_id",
		"run_attempt",
		"event_name",
		"ref",
		"commit_sha",
		"head_ref",
		"base_ref",
		"pr_number",
		"pr_title",
		"pr_state",
		"pr_author",
		"pr_created_at",
		"pr_merged_at",
		"pr_lead_time_minutes",
		"template_count",
		"terraform_file_count",
	})

	prNumber := ""
	prTitle := ""
	prState := ""
	prAuthor := ""
	prCreatedAt := ""
	prMergedAt := ""
	prLeadTime := ""

	if metrics.PullRequest != nil {
		prNumber = strconv.Itoa(metrics.PullRequest.Number)
		prTitle = metrics.PullRequest.Title
		prState = metrics.PullRequest.State
		prAuthor = metrics.PullRequest.Author
		prCreatedAt = metrics.PullRequest.CreatedAt
		prMergedAt = metrics.PullRequest.MergedAt
		if metrics.PullRequest.LeadTimeMinutes > 0 {
			prLeadTime = fmt.Sprintf("%.2f", metrics.PullRequest.LeadTimeMinutes)
		}
	}

	return writer.Write([]string{
		metrics.CollectedAt,
		metrics.Repository,
		metrics.Workflow,
		metrics.Job,
		metrics.RunID,
		metrics.RunAttempt,
		metrics.EventName,
		metrics.Ref,
		metrics.CommitSHA,
		metrics.HeadRef,
		metrics.BaseRef,
		prNumber,
		prTitle,
		prState,
		prAuthor,
		prCreatedAt,
		prMergedAt,
		prLeadTime,
		strconv.Itoa(metrics.TemplateCount),
		strconv.Itoa(metrics.TerraformFileCount),
	})
}

func writeTemplateInventoryCSV(path string, templates []TemplateInfo) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	_ = writer.Write([]string{
		"path",
		"scenario",
		"subject_id",
		"resource",
		"has_main_tf",
		"has_variables_tf",
		"has_outputs_tf",
		"has_versions_tf",
		"has_readme",
		"has_metadata",
		"tf_file_count",
	})

	for _, template := range templates {
		if err := writer.Write([]string{
			template.Path,
			template.Scenario,
			template.SubjectID,
			template.Resource,
			strconv.FormatBool(template.MainTF),
			strconv.FormatBool(template.VariablesTF),
			strconv.FormatBool(template.OutputsTF),
			strconv.FormatBool(template.VersionsTF),
			strconv.FormatBool(template.Readme),
			strconv.FormatBool(template.Metadata),
			strconv.Itoa(template.TFFileCount),
		}); err != nil {
			return err
		}
	}

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
			return "", fmt.Errorf("nao foi possivel localizar a raiz do projeto")
		}
		currentDir = parentDir
	}
}

func splitPath(path string) []string {
	return strings.FieldsFunc(filepath.ToSlash(path), func(r rune) bool {
		return r == '/'
	})
}

func fileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

func stringFromAny(value any) string {
	if value == nil {
		return ""
	}
	if str, ok := value.(string); ok {
		return str
	}
	return fmt.Sprintf("%v", value)
}

func intFromAny(value any) int {
	switch typed := value.(type) {
	case float64:
		return int(typed)
	case int:
		return typed
	case string:
		parsed, _ := strconv.Atoi(typed)
		return parsed
	default:
		return 0
	}
}

func boolFromAny(value any) bool {
	if value == nil {
		return false
	}
	if b, ok := value.(bool); ok {
		return b
	}
	return false
}

func fail(err error) {
	fmt.Fprintf(os.Stderr, "erro: %v\n", err)
	os.Exit(1)
}
