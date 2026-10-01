# IAM Role com IAM Policy anexada

Blueprint Terraform que provisiona uma IAM Role e uma IAM Policy de minimo privilegio anexada a ela via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela so existe atrelada a uma role com um principal de confianca definido (assume role).

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role) restrita aos principais informados.
- `aws_iam_policy.this` — policy de permissoes, construida a partir de `data.aws_iam_policy_document`.
- `aws_iam_role_policy_attachment.this` — anexa a policy criada a role criada.

## Postura de seguranca adotada

- Nenhum wildcard (`*`) e aceito em `policy_actions` ou `policy_resources` — validado via `validation` blocks nas variaveis.
- O trust policy so autoriza os principais explicitamente listados em `trusted_service_principals` e/ou `trusted_account_arns`.
- Suporte opcional a `external_id` para reforcar cenarios de acesso cross-account (condicao `sts:ExternalId`).
- Suporte opcional a `permissions_boundary_arn` para limitar o escopo maximo de permissoes da role.
- `force_detach_policies = true` evita que a role fique com policies orfas caso seja destruida.
- `max_session_duration` limitado por padrao a 3600 segundos (1 hora), configuravel entre 3600 e 43200.

## Uso

```
module "iam_role_policy" {
  source = "./"

  name_prefix                 = "minha-app"
  region                      = "us-east-1"
  trusted_service_principals  = ["lambda.amazonaws.com"]
  policy_actions              = ["s3:GetObject", "s3:ListBucket"]
  policy_resources            = ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]

  tags = {
    Ambiente = "dev"
  }
}
```

## Principais variaveis

| Nome | Descricao | Default |
|---|---|---|
| `name_prefix` | Prefixo dos nomes de role/policy | `"app"` |
| `trusted_service_principals` | Servicos AWS que podem assumir a role | `["ec2.amazonaws.com"]` |
| `trusted_account_arns` | ARNs IAM que podem assumir a role (cross-account) | `[]` |
| `external_id` | External ID exigido no assume role cross-account | `""` |
| `max_session_duration` | Duracao maxima de sessao (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `null` |
| `policy_actions` | Actions permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Recursos alvo das actions | bucket de exemplo |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Outputs

- `role_name`, `role_arn`, `role_unique_id`
- `policy_name`, `policy_arn`, `policy_id`
- `role_policy_attachment_id`

## Validacao local

```
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para `init`/`validate`; os valores padrao das variaveis sao suficientes para a checagem sintatica e semantica dos arquivos.
