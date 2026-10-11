# IAM Policy anexada a uma IAM Role

Blueprint Terraform para provisionar uma IAM Policy e uma IAM Role na AWS, com a policy anexada via `aws_iam_role_policy_attachment`, de forma que a policy nunca permanece solta (sem principal associado).

## Recursos criados

- `data.aws_iam_policy_document.trust` — trust policy (assume role policy) restrita a um unico principal configuravel (`var.trusted_principal_arn`), com suporte opcional a condicao `sts:ExternalId`. Nao permite `"*"` nem `AWS: "*"`.
- `data.aws_iam_policy_document.permissions` — documento de permissoes com acoes e recursos explicitos (sem uso de `"*"` em `actions` ou `resources`).
- `aws_iam_policy.this` — IAM Policy com o documento de permissoes acima.
- `aws_iam_role.this` — IAM Role com a trust policy restrita.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.

## Seguranca por padrao

- A trust policy aceita apenas um principal especifico (role, user ou conta root via ARN completo), validado por regex. Valores como `"*"` sao rejeitados na validacao da variavel.
- As variaveis `allowed_actions` e `allowed_resources` bloqueiam o curinga `"*"` via validacao, evitando permissoes administrativas amplas por engano.
- Nenhuma credencial ou valor sensivel fixo é usado; `external_id` é opcional e marcado como `sensitive`.
- Tags sao aplicadas tanto na role quanto na policy quando fornecidas.

## Uso

```hcl
module "iam_role" {
  source = "./"

  role_name             = "app-backend-role"
  policy_name           = "app-backend-policy"
  trusted_principal_arn = "arn:aws:iam::111122223333:role/ci-deployer"
  external_id           = "opcional-exemplo"

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject"
  ]

  allowed_resources = [
    "arn:aws:s3:::minha-app-bucket/*"
  ]

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default |
|---|---|---|---|
| `aws_region` | Regiao AWS | `string` | `"us-east-1"` |
| `role_name` | Nome da IAM Role | `string` | `"example-app-role"` |
| `policy_name` | Nome da IAM Policy | `string` | `"example-app-policy"` |
| `path` | Path IAM | `string` | `"/"` |
| `trusted_principal_arn` | ARN do principal autorizado a assumir a role | `string` | ARN de exemplo |
| `external_id` | External ID opcional da trust policy | `string` | `""` |
| `max_session_duration` | Duracao maxima da sessao (segundos) | `number` | `3600` |
| `allowed_actions` | Acoes IAM permitidas (sem `"*"`) | `list(string)` | `["s3:GetObject", "s3:ListBucket"]` |
| `allowed_resources` | ARNs de recursos permitidos (sem `"*"`) | `list(string)` | lista de exemplo |
| `tags` | Tags aplicadas aos recursos | `map(string)` | `{}` |

## Outputs

| Nome | Descricao |
|---|---|
| `role_name` | Nome da IAM Role criada |
| `role_arn` | ARN da IAM Role criada |
| `role_unique_id` | ID unico da IAM Role criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_id` | ID unico da IAM Policy criada |
| `attachment_id` | ID do attachment entre role e policy |

## Validacao

```bash
terraform init -backend=false
terraform validate
```
