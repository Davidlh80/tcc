# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy de menor privilegio e uma IAM Role dedicada, anexando a policy a role (a policy nunca fica solta, sem principal associado).

Caracteristicas de seguranca aplicadas por padrao:

- A trust policy (assume role policy) da role restringe o principal autorizado a `var.trusted_principal_arn`, configuravel por variavel. E proibido `Principal = "*"` ou `"AWS": "*"`.
- A statement `Effect = "Allow"` da policy e restrita apenas as `actions` e `resources` informados via variavel (`allowed_actions` e `allowed_resources`).
- E proibida, via `precondition` no recurso `aws_iam_policy`, qualquer combinacao de `Action = "*"` com `Resource = "*"` na mesma statement.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nome dos recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e todas as tags obrigatorias da organizacao sao aplicadas.

## 2. Variaveis

| Nome                    | Tipo           | Obrigatoria | Descricao                                                                                     |
|-------------------------|----------------|-------------|-------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                |
| `system`                 | `string`       | Sim         | Identificador curto do sistema/aplicacao, usado no nome padronizado.                            |
| `region`                 | `string`       | Nao         | Regiao AWS onde os recursos serao provisionados. Padrao: `us-east-1`.                           |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.                               |
| `policy_name`            | `string`       | Sim         | Finalidade/proposito da policy e da role, usado no nome padronizado (ex.: `readonly`).          |
| `allowed_actions`        | `list(string)` | Sim         | Lista de IAM Actions permitidas na statement Allow da policy.                                   |
| `allowed_resources`      | `list(string)` | Sim         | Lista de ARNs/recursos permitidos na statement Allow da policy.                                 |
| `trusted_principal_arn`  | `string`       | Sim         | ARN do principal autorizado a assumir a role. Nao pode ser `"*"`.                                |
| `max_session_duration`   | `number`       | Nao         | Duracao maxima (segundos) da sessao assumida via `sts:AssumeRole`. Padrao: `3600`.               |

## 3. Outputs

| Nome          | Descricao                                                     |
|---------------|-----------------------------------------------------------------|
| `policy_name` | Nome padronizado da IAM Policy criada.                          |
| `policy_arn`  | ARN da IAM Policy criada.                                       |
| `policy_id`   | ID da IAM Policy criada.                                        |
| `role_name`   | Nome padronizado da IAM Role a qual a policy foi anexada.       |
| `role_arn`    | ARN da IAM Role a qual a policy foi anexada.                     |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
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

  trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-role"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
