package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
)

type GroupKey struct {
	Scenario string
	Resource string
}

type GroupSummary struct {
	Scenario      string
	Resource      string
	TemplateCount int
	CompleteCount int
	MetadataCount int
}

func main() {
	projectRoot, err := findProjectRoot()
	if err != nil {
		fail(err)
	}

	inputPath := filepath.Join(projectRoot, "resultados", "metrics", "template-inventory.csv")
	outputPath := filepath.Join(projectRoot, "resultados", "metrics", "template-summary.csv")

	records, err := readCSV(inputPath)
	if err != nil {
		fail(err)
	}

	summary := summarize(records)
	if err := writeSummary(outputPath, summary); err != nil {
		fail(err)
	}

	fmt.Printf("Resumo gerado em: %s\n", outputPath)
}

func readCSV(path string) ([]map[string]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, fmt.Errorf("falha ao abrir %s: %w", path, err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	rows, err := reader.ReadAll()
	if err != nil {
		return nil, err
	}
	if len(rows) < 2 {
		return nil, nil
	}

	headers := rows[0]
	records := make([]map[string]string, 0, len(rows)-1)
	for _, row := range rows[1:] {
		record := map[string]string{}
		for i, header := range headers {
			if i < len(row) {
				record[header] = row[i]
			}
		}
		records = append(records, record)
	}
	return records, nil
}

func summarize(records []map[string]string) []GroupSummary {
	groups := map[GroupKey]*GroupSummary{}

	for _, record := range records {
		key := GroupKey{
			Scenario: record["scenario"],
			Resource: record["resource"],
		}
		if key.Scenario == "" || key.Resource == "" {
			continue
		}

		current, ok := groups[key]
		if !ok {
			current = &GroupSummary{Scenario: key.Scenario, Resource: key.Resource}
			groups[key] = current
		}

		current.TemplateCount++
		if isTrue(record["has_main_tf"]) && isTrue(record["has_variables_tf"]) && isTrue(record["has_outputs_tf"]) && isTrue(record["has_versions_tf"]) && isTrue(record["has_readme"]) {
			current.CompleteCount++
		}
		if isTrue(record["has_metadata"]) {
			current.MetadataCount++
		}
	}

	result := make([]GroupSummary, 0, len(groups))
	for _, value := range groups {
		result = append(result, *value)
	}

	sort.Slice(result, func(i, j int) bool {
		if result[i].Scenario == result[j].Scenario {
			return result[i].Resource < result[j].Resource
		}
		return result[i].Scenario < result[j].Scenario
	})

	return result
}

func writeSummary(path string, summary []GroupSummary) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	_ = writer.Write([]string{"scenario", "resource", "template_count", "complete_template_count", "metadata_count"})
	for _, row := range summary {
		if err := writer.Write([]string{
			row.Scenario,
			row.Resource,
			strconv.Itoa(row.TemplateCount),
			strconv.Itoa(row.CompleteCount),
			strconv.Itoa(row.MetadataCount),
		}); err != nil {
			return err
		}
	}
	return nil
}

func isTrue(value string) bool {
	return strings.EqualFold(value, "true")
}

func findProjectRoot() (string, error) {
	currentDir, err := os.Getwd()
	if err != nil {
		return "", err
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

func fail(err error) {
	fmt.Fprintf(os.Stderr, "erro: %v\n", err)
	os.Exit(1)
}
