# IAM Policy anexada a IAM Role

## Visao geral do recurso

Este template provisiona uma IAM Policy de minimo privilegio e uma IAM Role dedicada, com a policy anexada a role via `aws_iam_role_policy_attachment` (a policy nunca fica solta, sem principal associado).

Caracteristicas de seguranca implementadas:

- A trust policy (assume role policy) da role restringe o principal autorizado a assumir a role a um unico ARN, configuravel pela variavel `trusted_principal_arn`. Nao e permitido `Principal: "*"` ou `"AWS": "*"`.
- A statement `Effect: Allow` da policy e restrita exatamente as acoes (`allowed_actions`) e recursos (`allowed_resources`) informados por variavel.
- Uma precondicao (`lifecycle.precondition`) bloqueia a criacao da policy caso `allowed_actions` e `allowed_resources` contenham `"*"` simultaneamente, impedindo a combinacao `Action: "*"` com `Resource: "*"`.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura e tags seguem o padrao organizacional `tcc-iac-ia`.

Recursos criados:

- `aws_iam_policy.this`
- `aws_iam_role.this`
- `aws_iam_role_policy_attachment.this`

## Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                 |
|--------------------------|----------------|-------------|----------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                           |
| `system`                 | `string`       | Sim         | Nome curto do sistema, usado no padrao de nomenclatura.                   |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao criados. Padrao: `us-east-1`.           |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.         |
| `policy_name`            | `string`       | Sim         | Finalidade/nome curto da policy e da role, usado no padrao de nomenclatura.|
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a role (trust policy).        |
| `allowed_actions`        | `list(string)` | Sim         | Lista de acoes IAM permitidas na statement Allow da policy.               |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs de recursos permitidos na statement Allow da policy.        |

## Outputs

| Nome          | Descricao                                        |
|---------------|---------------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                        |
| `policy_arn`  | ARN da IAM Policy criada.                         |
| `policy_id`   | ID da IAM Policy criada.                          |
| `role_name`   | Nome da IAM Role criada e associada a policy.     |
| `role_arn`    | ARN da IAM Role criada e associada a policy.      |

## Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-cd-deployer"

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
