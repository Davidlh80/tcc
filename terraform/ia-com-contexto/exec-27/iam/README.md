# IAM Policy anexada a IAM Role

## Visao geral

Este template cria uma IAM Policy e uma IAM Role na AWS, com a policy anexada diretamente a role (nenhuma policy fica sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel via variavel, sem uso de `Principal: "*"` ou `"AWS": "*"`. A policy concede apenas `Effect: Allow` para as acoes e recursos informados por variavel, proibindo explicitamente qualquer statement que combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada. Os recursos seguem o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias da organizacao.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                  |
|--------------------------|----------------|-------------|----------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                             |
| `system`                  | `string`       | Nao         | Nome do sistema/aplicacao (padrao: `tcc`).                                                   |
| `region`                  | `string`       | Nao         | Regiao AWS onde os recursos serao criados (padrao: `us-east-1`).                             |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias do padrao organizacional.                 |
| `policy_name`             | `string`       | Sim         | Finalidade/sufixo que identifica o proposito da IAM Policy e da IAM Role (ex.: `readonly`).  |
| `trusted_principal_arn`   | `string`       | Sim         | ARN unico do principal autorizado a assumir a IAM Role. Nao aceita `"*"`.                    |
| `allowed_actions`         | `list(string)` | Sim         | Lista de acoes IAM permitidas pela policy. Nao aceita `"*"`.                                 |
| `allowed_resources`       | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam. Nao aceita `"*"`.         |

## Outputs

| Nome          | Descricao                                             |
|---------------|--------------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                              |
| `policy_arn`  | ARN da IAM Policy criada.                                |
| `policy_id`   | ID da IAM Policy criada.                                 |
| `role_name`   | Nome da IAM Role criada e associada a policy.            |
| `role_arn`    | ARN da IAM Role criada e associada a policy.             |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment            = "dev"
  system                 = "tcc"
  region                 = "us-east-1"
  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/app-service-role"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
