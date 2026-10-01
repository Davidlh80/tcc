# IAM Policy anexada a IAM Role

## Visao geral

Este modulo Terraform provisiona uma IAM Policy com privilegio minimo e uma IAM Role associada, seguindo o padrao organizacional `tcc-iac-ia`. A policy nunca fica solta: ela e anexada diretamente a role via `aws_iam_role_policy_attachment`. A trust policy (assume role policy) da role e restrita a um unico principal configuravel (`trusted_principal_arn`), sem uso de `Principal: "*"` ou `"AWS": "*"`. A statement `Allow` da policy e restrita exclusivamente as actions e aos recursos informados por variavel, e e proibida a combinacao `Action: "*"` com `Resource: "*"` na mesma statement (validado via `lifecycle.precondition`). Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Nomenclatura dos recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`:

- Policy: `<environment>-<system>-iam-policy-<policy_name>`
- Role: `<environment>-<system>-iam-role-<policy_name>`

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`                 | `string`       | Sim         | Identificador do sistema/aplicacao dono do recurso.                                            |
| `region`                 | `string`       | Sim         | Regiao AWS onde o provider ira operar.                                                         |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy/Role, usada como sufixo de nomenclatura (ex.: `readonly`).             |
| `allowed_actions`        | `list(string)` | Sim         | Lista de IAM Actions permitidas na statement Allow da policy.                                  |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement Allow da policy.                              |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao aceita `"*"`.        |

## Outputs

| Nome          | Descricao                                |
|---------------|--------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                 |
| `policy_arn`  | ARN da IAM Policy criada.                  |
| `policy_id`   | ID da IAM Policy criada.                   |
| `role_name`   | Nome da IAM Role criada.                   |
| `role_arn`    | ARN da IAM Role criada.                    |

## Exemplo de uso

```hcl
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

  trusted_principal_arn = "arn:aws:iam::123456789012:role/ci-cd-executor"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
