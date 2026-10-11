# IAM Policy anexada a IAM Role

Blueprint Terraform que provisiona uma IAM Policy e uma IAM Role, com a policy anexada via `aws_iam_role_policy_attachment` (nunca ficando solta, sem principal associado).

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role policy) restrita aos principais informados em `trusted_principal_arns`.
- `aws_iam_policy.this` — policy com as actions e resources definidos pelo usuario.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.
- `data.aws_iam_policy_document.assume_role` — documento da trust policy.
- `data.aws_iam_policy_document.this` — documento da policy de permissoes.

## Decisoes de seguranca

- A trust policy nunca permite `"*"` como principal: a variavel `trusted_principal_arns` rejeita esse valor via `validation`.
- A lista de actions (`policy_actions`) rejeita o wildcard `"*"` e qualquer action com sufixo `:*` (ex.: `iam:*`, `ec2:*`), evitando permissoes administrativas amplas.
- `force_detach_policies = true` evita que a role fique "trancada" por policies anexadas ao ser destruida.
- Suporte opcional a `sts:ExternalId` na trust policy para cenarios de acesso cross-account de terceiros (`require_external_id` + `external_id`).
- Suporte opcional a `permissions_boundary_arn` para limitar o escopo maximo de permissoes da role.
- Nenhum valor sensivel fixo no codigo; tudo vem de variaveis.

## Uso

```hcl
module "iam_role_with_policy" {
  source = "./"

  role_name   = "app-read-only-role"
  policy_name = "app-read-only-policy"

  trusted_principal_type  = "AWS"
  trusted_principal_arns  = ["arn:aws:iam::123456789012:root"]

  policy_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  policy_resources = [
    "arn:aws:s3:::minha-bucket",
    "arn:aws:s3:::minha-bucket/*",
  ]

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default |
|---|---|---|---|
| `role_name` | Nome da IAM Role | `string` | — |
| `role_description` | Descricao da role | `string` | `"Role gerenciada via Terraform com permissoes restritas."` |
| `role_path` | Path da role e da policy | `string` | `"/"` |
| `max_session_duration` | Duracao maxima da sessao (segundos) | `number` | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `string` | `""` |
| `trusted_principal_type` | Tipo de principal da trust policy | `string` | `"AWS"` |
| `trusted_principal_arns` | ARNs autorizados a assumir a role (sem `"*"`) | `list(string)` | — |
| `require_external_id` | Exige `sts:ExternalId` na trust policy | `bool` | `false` |
| `external_id` | Valor do ExternalId (sensivel) | `string` | `""` |
| `policy_name` | Nome da IAM Policy | `string` | — |
| `policy_description` | Descricao da policy | `string` | `"Policy gerenciada via Terraform com permissoes restritas."` |
| `policy_actions` | Actions permitidas (sem wildcard amplo) | `list(string)` | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Recursos alvo da policy | `list(string)` | exemplo de bucket S3 |
| `tags` | Tags aplicadas aos recursos | `map(string)` | `{}` |

## Outputs

| Nome | Descricao |
|---|---|
| `role_name` | Nome da IAM Role criada |
| `role_arn` | ARN da IAM Role criada |
| `role_id` | Unique ID da IAM Role criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_attachment_id` | ID do attachment entre policy e role |

## Validacao

```bash
terraform init -backend=false
terraform validate
```
