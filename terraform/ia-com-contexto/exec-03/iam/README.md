# IAM Policy

## Visao geral

Este modulo Terraform cria uma IAM Policy (`aws_iam_policy`) seguindo os padroes organizacionais de nomenclatura e tags do projeto `tcc-iac-ia`. A policy gerada contem uma unica statement com `Effect: Allow`, restrita as actions e aos resources informados via variavel. A combinacao de `Action: "*"` com `Resource: "*"` na mesma statement e bloqueada por uma precondition no recurso, e nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| environment | string | sim | Ambiente de implantacao (`dev`, `hml`, `prd`). |
| system | string | sim | Nome do sistema/produto ao qual o recurso pertence. |
| region | string | nao | Regiao AWS onde os recursos serao criados. Padrao: `us-east-1`. |
| additional_tags | map(string) | nao | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`. |
| policy_name | string | sim | Finalidade da IAM Policy, usada para compor o nome padronizado (ex.: `readonly`). |
| description | string | nao | Descricao da IAM Policy. Padrao: `"Gerenciada via Terraform."` |
| allowed_actions | list(string) | sim | Actions IAM permitidas na statement Allow. |
| allowed_resources | list(string) | sim | ARNs de recursos permitidos na statement Allow. |

## Outputs

| Nome | Descricao |
|---|---|
| policy_name | Nome da IAM Policy criada. |
| policy_arn | ARN da IAM Policy criada. |
| policy_id | ID da IAM Policy criada. |

## Exemplo de uso

module "iam_policy_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
