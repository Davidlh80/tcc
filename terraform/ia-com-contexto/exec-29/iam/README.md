# IAM Policy

## Visao geral

Este template Terraform cria uma IAM Policy (`aws_iam_policy`) seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao.

A policy gerada contem uma unica statement com `Effect: Allow`, restrita exclusivamente as actions e aos recursos informados via variavel. O template impede explicitamente a criacao de uma statement que combine `Action: "*"` com `Resource: "*"`, e nao anexa nem replica policies gerenciadas administrativas (ex.: `AdministratorAccess`).

O nome do recurso segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, resultando em nomes como `dev-tcc-iam-readonly` ou `prd-tcc-iam-readonly`.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| `environment` | `string` | Sim | Ambiente de implantacao (`dev`, `hml` ou `prd`). |
| `system` | `string` | Nao (default: `tcc`) | Nome do sistema ou projeto ao qual o recurso pertence. |
| `region` | `string` | Nao (default: `us-east-1`) | Regiao AWS onde os recursos serao provisionados. |
| `additional_tags` | `map(string)` | Nao (default: `{}`) | Tags adicionais mescladas com as tags obrigatorias. |
| `policy_name` | `string` | Sim | Finalidade da IAM Policy, usada como sufixo no padrao de nomenclatura (ex.: `readonly`). |
| `policy_description` | `string` | Nao (default: `"IAM Policy gerenciada via Terraform."`) | Descricao da IAM Policy. |
| `allowed_actions` | `list(string)` | Sim | Lista de actions IAM permitidas (`Effect: Allow`). |
| `allowed_resources` | `list(string)` | Sim | Lista de ARNs de recursos permitidos (`Effect: Allow`). |

## Outputs

| Nome | Descricao |
|---|---|
| `policy_name` | Nome da IAM Policy criada. |
| `policy_arn` | ARN da IAM Policy criada. |
| `policy_id` | ID unico da IAM Policy criada. |

## Exemplo de uso

```hcl
module "iam_policy_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name        = "readonly"
  policy_description = "Policy de leitura para buckets S3 especificos."

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
