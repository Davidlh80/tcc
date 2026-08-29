# Experimento IaC com Inteligência Artificial

Este repositório contém a estrutura de desenvolvimento do experimento utilizado no TCC, cujo objetivo é avaliar o uso de Inteligência Artificial na geração de templates de Infraestrutura como Código (IaC).

O estudo compara três cenários:

1. Desenvolvimento manual de templates Terraform;
2. Geração por IA sem contexto organizacional;
3. Geração por IA com contexto organizacional.

A avaliação considera eficiência operacional, padronização, conformidade e segurança, utilizando validações automatizadas com Terraform, Checkov e Trivy.

## Estrutura do repositório

```text
.
├── contexto/
├── docs/
├── prompts/
├── requisitos/
├── resultados/
├── scripts/
├── terraform/
├── .github/workflows/
└── .vscode/
```

## Cenários avaliados

### Manual
Templates criados manualmente pelos participantes.

### IA sem contexto
Templates gerados por Inteligência Artificial a partir de prompts contendo apenas os requisitos técnicos do recurso.

### IA com contexto
Templates gerados por Inteligência Artificial utilizando os mesmos requisitos técnicos, acrescidos do contexto organizacional.

## Recursos avaliados

- Amazon S3;
- AWS IAM;
- Security Group.

## Validações previstas

- `terraform fmt`;
- `terraform validate`;
- análise de segurança com Checkov e Trivy;
- verificação de conformidade com requisitos;
- execução controlada com LocalStack, quando aplicável;
- coleta de métricas de tempo, falhas e vulnerabilidades.

## Estado atual

Este repositório está em fase inicial de estruturação. Os templates Terraform ainda serão adicionados às pastas correspondentes aos três cenários avaliados.

