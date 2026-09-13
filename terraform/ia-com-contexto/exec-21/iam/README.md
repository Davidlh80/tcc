# IAM Policy - Blueprint Terraform

## 1. Visão geral

Este blueprint provisiona uma IAM Policy AWS gerenciada pelo cliente, seguindo o princípio do menor privilégio. A policy contém uma única statement `Allow`, cujas ações e recursos são definidos exclusivamente por variável, sem uso de wildcard combinado (`Action: "*"` com `Resource: "*"`) e sem replicar ou anexar policies gerenciadas administrativas (ex.: `AdministratorAccess`).

O nome do recurso segue o padrão organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `dev-tcc-iam-readonly`.

## 2. Variáveis

| Nome | Tipo | Obrigatória | Descrição |
|---|---|---|---|
| environment | string | Sim | Ambiente de implantação (`dev`, `hml` ou `prd`). |
| system | string | Não (default `tcc`) | Identificador do sistema/projeto ao qual o recurso pertence. |
| region | string | Não (default `us-east-1`) | Região AWS onde os recursos serão provisionados. |
| additional_tags | map(string) | Não (default `{}`) | Tags adicionais mescladas com as tags obrigatórias. |
| policy_name | string | Sim | Finalidade da IAM Policy, usada para compor o nome padronizado (ex.: `readonly`). |
| policy_description | string | Não (default `"IAM Policy gerenciada via Terraform."`) | Descrição da IAM Policy. |
| allowed_actions | list(string) | Sim | Ações IAM permitidas na statement Allow. |
| allowed_resources | list(string) | Sim | ARNs de recursos permitidos na statement Allow. |

## 3. Outputs

| Nome | Descrição |
|---|---|
| policy_name | Nome da IAM Policy criada. |
| policy_arn | ARN da IAM Policy criada. |
| policy_id | ID da IAM Policy criada. |

## 4. Exemplo de uso

    module "iam_policy_readonly" {
      source = "./iam"

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
