# IAM Policy anexada a IAM Role

## Visão geral

Este template provisiona uma IAM Policy gerenciada pelo cliente e uma IAM Role, anexando a policy à role por meio de `aws_iam_role_policy_attachment`. A policy nunca é criada de forma solta: ela é sempre associada a um principal (a role).

A trust policy (assume role policy) da role é restrita a um único principal configurável via variável (`trusted_principal_arn`), sendo proibido o uso de `Principal: "*"` ou `"AWS": "*"`.

A policy de permissões contém uma única statement com `Effect = Allow`, cujas `Action` e `Resource` são definidas integralmente por variáveis (`allowed_actions` e `allowed_resources`). Uma precondição em tempo de plano/apply impede que essa statement combine `Action = "*"` com `Resource = "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) é anexada ou replicada por este template.

Os nomes de policy e role seguem o padrão organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo: `prd-tcc-iam-readonly`.

## Variáveis

| Nome                    | Tipo           | Obrigatória | Descrição                                                                                      |
|-------------------------|----------------|-------------|--------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                |
| `system`                 | `string`       | Sim         | Nome curto do sistema/aplicação dono do recurso.                                                |
| `region`                 | `string`       | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                           |
| `additional_tags`        | `map(string)`  | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.                                |
| `policy_name`            | `string`       | Sim         | Finalidade da IAM Policy, usada no padrão de nomenclatura.                                       |
| `role_name`              | `string`       | Sim         | Finalidade da IAM Role, usada no padrão de nomenclatura.                                         |
| `allowed_actions`        | `list(string)` | Sim         | Actions IAM permitidas na policy (`Effect = Allow`).                                             |
| `allowed_resources`      | `list(string)` | Sim         | ARNs de recursos aos quais as actions permitidas se aplicam.                                     |
| `trusted_principal_arn`  | `string`       | Sim         | ARN do principal (IAM User/Role) ou service principal autorizado a assumir a role.               |
| `max_session_duration`   | `number`       | Não         | Duração máxima (segundos) da sessão assumida via `sts:AssumeRole`. Padrão: `3600`.               |

## Outputs

| Nome          | Descrição                                                |
|---------------|-----------------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                                 |
| `policy_arn`  | ARN da IAM Policy criada.                                  |
| `policy_id`   | ID da IAM Policy criada.                                   |
| `role_name`   | Nome da IAM Role criada e associada à policy.               |
| `role_arn`    | ARN da IAM Role criada e associada à policy.                |
| `role_id`     | ID único da IAM Role criada.                                |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name = "readonly"
  role_name   = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*"
  ]

  trusted_principal_arn = "arn:aws:iam::123456789012:role/prd-tcc-app-role"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
