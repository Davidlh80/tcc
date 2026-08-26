# Requisitos Gerais dos Templates Terraform

Todos os templates produzidos no experimento devem atender a estes requisitos.

## Estrutura mínima

Cada template deve possuir `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` e `README.md`.

## Requisitos técnicos

- Utilizar Terraform e declarar o provider AWS;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis no código;
- ser executável com `terraform init` e `terraform validate`;
- seguir a formatação de `terraform fmt`.

## Qualidade e segurança

- Manter código legível, nomes claros e README de uso;
- evitar duplicação desnecessária;
- evitar permissões excessivas e exposição pública sem justificativa;
- priorizar configurações seguras por padrão;
- permitir análise automatizada por Checkov e Trivy.
