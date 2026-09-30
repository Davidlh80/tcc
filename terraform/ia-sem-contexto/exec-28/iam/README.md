# IAM Role com IAM Policy Anexada

Blueprint Terraform que provisiona uma IAM Role, uma IAM Policy dedicada e o anexo entre ambas via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e sempre criada e anexada a uma role especifica na mesma execucao.

Este experimento foi gerado sem contexto organizacional. Todas as decisoes de nomenclatura, principal de confianca, acoes e recursos permitidos, tags e variaveis foram feitas com base em boas praticas gerais de mercado para Terraform e AWS, priorizando o principio do menor privilegio.

## Recursos criados

- `data.aws_iam_policy_document.assume_role` — trust policy da role (define quem pode assumi-la).
- `data.aws_iam_policy_document.permissions` — documento de permissoes da policy.
- `aws_iam_role.this` — a IAM Role.
- `aws_iam_policy.this` — a IAM Policy com as permissoes.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.

## Decisoes de seguranca

- Nenhum wildcard `*` e permitido em `actions` ou `resources` dos statements da policy (validado via `variable "policy_statements"`).
- O assume role exige explicitamente ao menos um principal de confianca (`trusted_service_principals` ou `trusted_aws_principals`); nao ha principal `*` (wildcard) por padrao.
- Suporte a `external_id` para reforcar cenarios de assume role cross-account.
- Suporte opcional a `permissions_boundary_arn` para limitar o escopo maximo de permissoes da role.
- Nenhuma credencial ou valor sensivel esta fixado no codigo; tudo e parametrizavel via variaveis.
- O statement de exemplo (`policy_statements` default) usa ARNs de placeholder (`REPLACE_WITH_BUCKET_NAME`) que devem ser substituidos por recursos reais antes do uso em producao.

## Uso

```
module "iam_role_policy" {
  source = "./"

  role_name   = "app-service-role"
  policy_name = "app-service-policy"

  trusted_service_principals = ["lambda.amazonaws.com"]

  policy_statements = [
    {
      sid       = "AllowReadAppBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::my-app-bucket",
        "arn:aws:s3:::my-app-bucket/*"
      ]
      conditions = []
    }
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `region` | Regiao AWS usada pelo provider | `us-east-1` |
| `role_name` | Nome da IAM Role | (obrigatorio) |
| `role_path` | Path da IAM Role | `/` |
| `max_session_duration` | Duracao maxima de sessao (segundos) | `3600` |
| `permissions_boundary_arn` | ARN da permissions boundary | `null` |
| `trusted_service_principals` | Service principals que podem assumir a role | `["lambda.amazonaws.com"]` |
| `trusted_aws_principals` | ARNs AWS que podem assumir a role | `[]` |
| `external_id` | External ID exigido no assume role | `null` |
| `policy_name` | Nome da IAM Policy | (obrigatorio) |
| `policy_statements` | Lista de statements da policy | ver `variables.tf` |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Outputs principais

| Nome | Descricao |
|---|---|
| `role_arn` | ARN da IAM Role criada |
| `role_name` | Nome da IAM Role criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `role_policy_attachment_id` | ID do attachment role/policy |

## Validacao

```
terraform init -backend=false
terraform validate
terraform fmt -check
```

Nenhum backend remoto e utilizado e nenhuma credencial real e necessaria para `init` e `validate`.
