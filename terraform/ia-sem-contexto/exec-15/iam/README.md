# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Policy escopada, anexada a uma IAM Role com trust policy (assume role policy) restrita a principals configuraveis.

## Recursos criados

- `aws_iam_role.this`: Role com `assume_role_policy` restrita aos ARNs informados em `trusted_principal_arns`. Nunca permite `"*"` ou `AWS: "*"` como principal.
- `aws_iam_policy.this`: Policy com permissoes definidas por `allowed_actions` e `resource_arns`, evitando acoes administrativas (`iam:*`) e wildcard total (`"*"`) em acoes e recursos.
- `aws_iam_role_policy_attachment.this`: Anexa a policy criada diretamente a role criada, garantindo que a policy nunca fique solta, sem nenhum principal associado.

## Seguranca por padrao

- A trust policy exige que `trusted_principal_arns` seja uma lista nao vazia de ARNs concretos; a criacao falha se algum valor for `"*"`.
- `allowed_actions` e `resource_arns` sao validados para rejeitar `"*"` e, no caso das acoes, `iam:*`.
- `permissions_boundary_arn` permite aplicar uma permissions boundary adicional, mas e opcional.
- `max_session_duration` e limitado ao intervalo valido aceito pelo IAM (3600 a 43200 segundos).

## Uso

```
module "scoped_iam_role" {
  source = "./"

  role_name   = "ci-deploy-role"
  policy_name = "ci-deploy-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/ci-pipeline-role",
  ]

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject",
  ]

  resource_arns = [
    "arn:aws:s3:::my-deploy-bucket/*",
  ]

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
```

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | `app-scoped-role` |
| `policy_name` | Nome da IAM Policy | `app-scoped-policy` |
| `trusted_principal_arns` | ARNs autorizados a assumir a role | (obrigatorio) |
| `allowed_actions` | Acoes permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `resource_arns` | Recursos cobertos pela policy | `["arn:aws:s3:::example-bucket/*"]` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `""` |
| `max_session_duration` | Duracao maxima da sessao assumida | `3600` |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Outputs principais

| Nome | Descricao |
|---|---|
| `role_arn` | ARN da Role criada |
| `policy_arn` | ARN da Policy criada |
| `policy_attachment_id` | ID do attachment entre Role e Policy |

## Validacao

```
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e nenhuma credencial real sao necessarios para validacao sintatica.
