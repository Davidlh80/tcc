# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy de menor privilegio e uma IAM Role dedicada, com a policy anexada a role (nenhum recurso fica solto, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel por variavel, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A policy nao permite a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement, e a statement `Effect: Allow` fica restrita exclusivamente as actions e aos recursos informados via variavel. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Os nomes dos recursos seguem o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`:

- IAM Policy: `<environment>-<system>-iam-<policy_name>`
- IAM Role: `<environment>-<system>-iam-role-<policy_name>`

Todos os recursos recebem as tags obrigatorias da organizacao (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`), mescladas com eventuais `additional_tags`.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`             | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                  | `string`       | Sim         | Nome do sistema/aplicacao ao qual o recurso pertence.                                         |
| `region`                  | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Default: `us-east-1`.                        |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias. Default: `{}`.                                |
| `policy_name`              | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: `readonly`).     |
| `trusted_principal_arn`    | `string`       | Sim         | ARN do principal especifico autorizado a assumir a IAM Role. Nao pode ser `*`.                |
| `allowed_actions`          | `list(string)` | Sim         | Actions IAM permitidas na policy (`Effect = Allow`).                                          |
| `allowed_resources`        | `list(string)` | Sim         | ARNs de recursos aos quais as actions permitidas se aplicam.                                  |

## Outputs

| Nome          | Descricao                                              |
|---------------|---------------------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                              |
| `policy_arn`   | ARN da IAM Policy criada.                                |
| `policy_id`    | ID da IAM Policy criada.                                 |
| `role_name`    | Nome da IAM Role criada e associada a policy.            |
| `role_arn`     | ARN da IAM Role criada e associada a policy.             |
| `role_id`      | ID da IAM Role criada e associada a policy.              |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./exec-XX/iam"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-cd-deployer"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
