# IAM Policy - dev-tcc-iam-<finalidade>

## 1. Visao geral

Este template provisiona uma IAM Policy da AWS seguindo o padrao organizacional de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-iam-readonly`).

A policy e composta por uma unica statement com `Effect: Allow`, restrita exclusivamente as acoes e aos recursos informados via variavel. O template impede, atraves de uma precondicao de ciclo de vida, que a statement combine `Action: "*"` com `Resource: "*"` na mesma regra, e nao anexa nem replica policies gerenciadas administrativas (ex.: `AdministratorAccess`).

## 2. Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|------|------|-------------|-----------|
| `environment` | `string` | Sim | Ambiente de implantacao (`dev`, `hml` ou `prd`). |
| `system` | `string` | Nao (default `tcc`) | Nome do sistema ou projeto ao qual o recurso pertence. |
| `region` | `string` | Nao (default `us-east-1`) | Regiao AWS onde os recursos serao provisionados. |
| `additional_tags` | `map(string)` | Nao (default `{}`) | Tags adicionais mescladas as tags obrigatorias da organizacao. |
| `policy_name` | `string` | Sim | Finalidade da policy, usada na composicao do nome padronizado (ex.: `readonly`). |
| `policy_description` | `string` | Nao | Descricao funcional da IAM Policy. |
| `allowed_actions` | `list(string)` | Sim | Lista de acoes IAM permitidas na statement Allow. |
| `allowed_resources` | `list(string)` | Sim | Lista de ARNs de recursos aos quais a statement Allow se aplica. |

## 3. Outputs

| Nome | Descricao |
|------|-----------|
| `policy_name` | Nome da IAM Policy criada. |
| `policy_arn` | ARN da IAM Policy criada. |
| `policy_id` | ID da IAM Policy criada. |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./"

      environment = "dev"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

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
