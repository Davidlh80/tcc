# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy de minimo privilegio anexada a uma IAM Role dedicada. A Role possui uma trust policy (assume role policy) restrita a um unico principal configuravel (`trusted_principal_arn`), sem uso de `Principal: "*"`. A policy permite somente as actions e recursos informados via variavel, com `Effect: Allow` restrito a esse conjunto. E proibido combinar `Action: "*"` com `Resource: "*"` na mesma statement (validado em tempo de `plan`/`apply`) e nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo.

Nomenclatura dos recursos:

- IAM Policy: `<environment>-<system>-iam-<policy_name>`
- IAM Role: `<environment>-<system>-iam-<policy_name>-role`

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                 |
|--------------------------|----------------|:-----------:|-----------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                             |
| `system`                  | `string`       | Sim         | Nome do sistema/projeto ao qual o recurso pertence.                         |
| `region`                  | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.       |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.           |
| `policy_name`             | `string`       | Sim         | Finalidade/sufixo que identifica a IAM Policy e a IAM Role (ex.: `readonly`). |
| `trusted_principal_arn`   | `string`       | Sim         | ARN unico do principal autorizado a assumir a IAM Role (trust policy).      |
| `allowed_actions`         | `list(string)` | Sim         | Lista de IAM Actions permitidas na policy.                                  |
| `allowed_resources`       | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as actions permitidas se aplicam.       |
| `max_session_duration`    | `number`       | Nao         | Duracao maxima (segundos) da sessao assumida pela Role. Padrao: `3600`.     |

## Outputs

| Nome          | Descricao                            |
|---------------|---------------------------------------|
| `policy_name` | Nome da IAM Policy criada.            |
| `policy_arn`  | ARN da IAM Policy criada.             |
| `policy_id`   | ID da IAM Policy criada.              |
| `role_name`   | Nome da IAM Role criada.              |
| `role_arn`    | ARN da IAM Role criada.               |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./iam"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/app-service-role"

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
```
