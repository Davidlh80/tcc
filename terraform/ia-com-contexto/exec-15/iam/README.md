# IAM Policy anexada a IAM Role

## Visao geral do recurso

Este template cria uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role via `aws_iam_role_policy_attachment` (a policy nunca fica sem um principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel por variavel, sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`. A statement da policy tem `Effect: Allow` restrito exatamente as `allowed_actions` e `allowed_resources` informadas por variavel, e uma precondicao de ciclo de vida bloqueia o plano/apply caso `Action: "*"` e `Resource: "*"` sejam combinados na mesma statement. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Nomenclatura seguindo o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`:

- Policy: `<environment>-<system>-iam-<purpose>`
- Role: `<environment>-<system>-iam-<purpose>-role`

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                 |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                            |
| `system`                  | `string`       | Sim         | Nome do sistema/projeto ao qual o recurso pertence.                        |
| `region`                  | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao `us-east-1`.       |
| `additional_tags`         | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao.         |
| `purpose`                 | `string`       | Sim         | Finalidade da IAM Policy/Role, usada na nomenclatura padronizada.          |
| `policy_description`      | `string`       | Nao         | Descricao da IAM Policy criada.                                            |
| `allowed_actions`         | `list(string)` | Sim         | Lista de actions IAM permitidas na policy.                                 |
| `allowed_resources`       | `list(string)` | Sim         | Lista de ARNs/recursos aos quais as actions permitidas se aplicam.         |
| `trusted_principal_arn`   | `string`       | Sim         | ARN do principal autorizado a assumir a role. Nao aceita `"*"`.            |
| `max_session_duration`    | `number`       | Nao         | Duracao maxima (segundos) da sessao assumida pela role. Padrao `3600`.     |

## Outputs

| Nome           | Descricao                                  |
|----------------|---------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                  |
| `policy_arn`   | ARN da IAM Policy criada.                   |
| `policy_id`    | ID da IAM Policy criada.                    |
| `role_name`    | Nome da IAM Role criada.                    |
| `role_arn`     | ARN da IAM Role criada.                     |
| `role_id`      | ID (unique ID) da IAM Role criada.          |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*",
  ]

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-role"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
