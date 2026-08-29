# Experimento IaC com InteligÃªncia Artificial

Este repositÃ³rio contÃ©m a estrutura de desenvolvimento do experimento utilizado no TCC, cujo objetivo Ã© avaliar o uso de InteligÃªncia Artificial na geraÃ§Ã£o de templates de Infraestrutura como CÃ³digo (IaC).

O estudo compara trÃªs cenÃ¡rios:

1. Desenvolvimento manual de templates Terraform;
2. GeraÃ§Ã£o por IA sem contexto organizacional;
3. GeraÃ§Ã£o por IA com contexto organizacional.

A avaliaÃ§Ã£o considera eficiÃªncia operacional, padronizaÃ§Ã£o, conformidade e seguranÃ§a, utilizando validaÃ§Ãµes automatizadas com Terraform, Checkov e Trivy.

## Estrutura do repositÃ³rio

```text
.
â”œâ”€â”€ contexto/
â”œâ”€â”€ docs/
â”œâ”€â”€ prompts/
â”œâ”€â”€ requisitos/
â”œâ”€â”€ resultados/
â”œâ”€â”€ scripts/
â”œâ”€â”€ terraform/
â”œâ”€â”€ .github/workflows/
â””â”€â”€ .vscode/
```

## CenÃ¡rios avaliados

### Manual
Templates criados manualmente pelos participantes.

### IA sem contexto
Templates gerados por InteligÃªncia Artificial a partir de prompts contendo apenas os requisitos tÃ©cnicos do recurso.

### IA com contexto
Templates gerados por InteligÃªncia Artificial utilizando os mesmos requisitos tÃ©cnicos, acrescidos do contexto organizacional.

## Recursos avaliados

- Amazon S3;
- AWS IAM;
- Security Group.

## ValidaÃ§Ãµes previstas

- `terraform fmt`;
- `terraform validate`;
- anÃ¡lise de seguranÃ§a com Checkov e Trivy;
- verificaÃ§Ã£o de conformidade com requisitos;
- execuÃ§Ã£o controlada com LocalStack, quando aplicÃ¡vel;
- coleta de mÃ©tricas de tempo, falhas e vulnerabilidades.

## Estado atual

A estrutura experimental, os scripts e a primeira versÃ£o dos pipelines estÃ£o implementados. Antes da coleta oficial, serÃ¡ realizado o teste controlado descrito em `docs/plano-testes-pipelines.md`. Os templates da amostra ainda serÃ£o adicionados aos trÃªs cenÃ¡rios avaliados.

## Piloto local com cinco geraÃ§Ãµes

No PowerShell, a partir da raiz do repositÃ³rio, configure a chave somente na sessÃ£o atual e gere cinco templates S3:

```powershell
$env:OPENAI_API_KEY="sua-chave"
go run ./scripts/generate-blueprint -scenario ia-com-contexto -resource s3 -start-execution 1 -execution-count 5
```

O comando gera ou substitui `exec-01` atÃ© `exec-05`. Cada `metadata.yml` registra o inÃ­cio, o fim, a duraÃ§Ã£o da chamada Ã  API e a duraÃ§Ã£o total da geraÃ§Ã£o.

Depois de revisar os arquivos, envie-os em uma branch de teste usando `#teste` na mensagem do commit:

```powershell
git add terraform/ia-com-contexto/exec-01 terraform/ia-com-contexto/exec-02 terraform/ia-com-contexto/exec-03 terraform/ia-com-contexto/exec-04 terraform/ia-com-contexto/exec-05
git commit -m "test: piloto de cinco geracoes #teste"
git push
```

O workflow `LocalStack Pilot Test` identifica os diretÃ³rios S3 alterados, limita o lote a cinco templates e usa um Ãºnico contÃªiner LocalStack. Para cada diretÃ³rio, executa `init`, `plan`, `apply`, verifica o bucket e executa `destroy`. O relatÃ³rio `pilot-results.csv` Ã© disponibilizado como artefato mesmo quando houver falhas.

O mesmo workflow pode ser iniciado manualmente em **Actions > LocalStack Pilot Test > Run workflow**, informando o cenÃ¡rio, a primeira execuÃ§Ã£o e uma quantidade entre um e cinco.
