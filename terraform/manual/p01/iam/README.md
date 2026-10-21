# IAM - p01

Cria uma policy IAM, uma role e a trust policy que permite apenas ao principal
informado assumir a role. A policy e anexada a role, segue o principio do menor
privilegio e nao usa permissoes administrativas nem curinga amplo.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
| --- | --- | --- | --- |
| `policy_name` | `string` | sim | Nome da policy IAM. |
| `role_name` | `string` | sim | Nome da role IAM. |
| `environment` | `string` | sim | Ambiente do recurso: `dev` ou `prd`. |
| `trusted_principal_arn` | `string` | sim | ARN do principal autorizado a assumir a role, sem curinga. |
| `allowed_actions` | `list(string)` | sim | Acoes permitidas pela policy, no formato `servico:Acao`. |
| `allowed_resources` | `list(string)` | sim | ARNs dos recursos liberados pela policy. |
| `additional_tags` | `map(string)` | nao | Tags adicionais aplicadas aos recursos. |

## Outputs

| Nome | Descricao |
| --- | --- |
| `policy_name` | Nome da policy criada. |
| `policy_arn` | ARN da policy criada. |
| `policy_id` | ID da policy criada. |
| `role_name` | Nome da role criada. |
| `role_arn` | ARN da role criada. |

## Uso

```hcl
policy_name           = "dev-tcc-iam-readonly"
role_name             = "dev-tcc-iam-readonly"
environment           = "dev"
trusted_principal_arn = "arn:aws:iam::123456789012:role/app"
allowed_actions       = ["s3:GetObject", "s3:ListBucket"]
allowed_resources     = ["arn:aws:s3:::tcc-docs", "arn:aws:s3:::tcc-docs/*"]
additional_tags       = { Project = "tcc" }
```

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
```
