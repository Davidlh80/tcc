# IAM Policy anexada a IAM Role

## Visao geral

Este template provisiona uma IAM Policy de minimo privilegio anexada a uma IAM Role dedicada, seguindo os padroes organizacionais de nomenclatura, tags e governanca de IaC.

Caracteristicas principais:

- A IAM Policy nunca fica solta: ela e sempre anexada a uma IAM Role via `aws_iam_role_policy_attachment`.
- A trust policy (assume role policy) da Role restringe o principal autorizado a um unico ARN configuravel (`trusted_principal_arn`), sem permitir `Principal = "*"` nem `"AWS" = "*"`.
- A statement da policy possui `Effect = Allow` restrito exatamente as `allowed_actions` e `allowed_resources` informadas por variavel.
- Uma precondicao (`lifecycle.precondition`) impede que a policy combine `Action = "*"` com `Resource = "*"` na mesma statement.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada neste template.
- Nomenclatura dos recursos segue o padrao `<ambiente>-<sistema>-iam-<finalidade>`, com a Role utilizando o sufixo `-role` para diferenciacao (ex.: `prd-tcc-iam-readonly` para a policy e `prd-tcc-iam-readonly-role` para a role).
- Tags obrigatorias da organizacao (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`) sao aplicadas em todos os recursos que suportam tags (IAM Role e IAM Policy), mescladas com `additional_tags`.

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                   |
|--------------------------|----------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                 | `string`       | Sim         | Nome curto do sistema/aplicacao, usado na nomenclatura.                                       |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao criados. Padrao: `us-east-1`.                               |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.              |
| `policy_name`             | `string`       | Sim         | Finalidade da Policy/Role, usada no padrao `<ambiente>-<sistema>-iam-<finalidade>`.           |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a Role. Nao aceita `"*"`.                          |
| `allowed_actions`        | `list(string)` | Sim         | Lista de actions IAM permitidas (`Effect = Allow`) na policy.                                 |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos aos quais as `allowed_actions` se aplicam.                           |

## Outputs

| Nome          | Descricao                              |
|---------------|------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.               |
| `policy_arn`  | ARN da IAM Policy criada.                |
| `policy_id`   | ID da IAM Policy criada.                 |
| `role_name`   | Nome da IAM Role criada.                 |
| `role_arn`    | ARN da IAM Role criada.                  |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/app-execution-role"

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
