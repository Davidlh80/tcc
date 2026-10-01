# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy e uma IAM Role na AWS, com a policy anexada diretamente a role (sem policies soltas, sem principal associado). A trust policy (assume role policy) da role e restrita a um unico principal configuravel, sem uso de curingas (`"*"`) no `Principal`. A policy de permissoes aplica `Effect: Allow` apenas para as acoes e recursos informados por variavel, e proibe explicitamente qualquer statement que combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este template.

Recursos criados:

- `aws_iam_role.this`
- `aws_iam_policy.this`
- `aws_iam_role_policy_attachment.this`

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                      |
|--------------------------|----------------|-------------|--------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                 |
| `system`                 | `string`       | Sim         | Nome do sistema/produto, usado na padronizacao de nomes.                                         |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                            |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao. Padrao: `{}`.                      |
| `policy_name`            | `string`       | Sim         | Finalidade/identificador da policy e da role, usado na composicao do nome padronizado.            |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a role. Nao aceita curinga (`"*"`).                   |
| `allowed_actions`        | `list(string)` | Sim         | Lista de acoes IAM permitidas (`Effect: Allow`).                                                  |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as `allowed_actions` se aplicam (`Effect: Allow`).            |

## Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.              |
| `policy_arn`  | ARN da IAM Policy criada.               |
| `policy_id`   | ID da IAM Policy criada.                |
| `role_name`   | Nome da IAM Role criada.                |
| `role_arn`    | ARN da IAM Role criada.                 |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment            = "dev"
  system                 = "tcc"
  region                 = "us-east-1"
  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-cd-deployer"

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
