# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Role com uma trust policy restrita a principals configuraveis e uma IAM Policy gerenciada com permissoes limitadas, anexada diretamente a essa role.

## Recursos criados

- `aws_iam_role.this`: role com assume role policy restrita aos ARNs informados em `trusted_principal_arns` (nunca `*` ou conta wildcard).
- `aws_iam_policy.this`: policy gerenciada contendo apenas as acoes (`allowed_actions`) e recursos (`resource_arns`) configurados, sem wildcard total.
- `aws_iam_role_policy_attachment.this`: anexa a policy a role, garantindo que a policy nunca fique solta sem principal associado.

## Decisoes de seguranca

- A trust policy (`data.aws_iam_policy_document.assume_role`) exige uma lista nao vazia de principals especificos; validacoes de variavel bloqueiam `"*"` e ARNs de conta com wildcard (`arn:aws:iam::*:...`).
- `allowed_actions` bloqueia, via validacao, o wildcard total (`*`) e wildcards de servico completo (ex.: `iam:*`, `s3:*`), reduzindo o risco de permissoes administrativas.
- `resource_arns` nao aceita `*`, forcando o escopo das acoes a recursos especificos.
- Suporte opcional a `sts:ExternalId` na trust policy (`external_id`) para mitigar o problema do confused deputy em cenarios de cross-account.
- Tags sao aplicadas tanto na role quanto na policy para rastreabilidade.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name               = "app-backend-role"
  policy_name             = "app-backend-policy"
  trusted_principal_arns  = ["arn:aws:iam::123456789012:role/ci-cd-deployer"]
  allowed_actions         = ["s3:GetObject", "s3:ListBucket"]
  resource_arns           = ["arn:aws:s3:::app-backend-bucket", "arn:aws:s3:::app-backend-bucket/*"]

  tags = {
    Environment = "staging"
    Owner       = "team-backend"
  }
}
```

## Variaveis principais

| Nome | Descricao | Obrigatorio |
|---|---|---|
| `trusted_principal_arns` | ARNs autorizados a assumir a role | Sim |
| `allowed_actions` | Acoes permitidas pela policy | Nao (default minimo de leitura em S3) |
| `resource_arns` | Recursos aos quais as acoes se aplicam | Nao (default aponta para bucket de exemplo) |
| `external_id` | ExternalId exigido na trust policy | Nao |
| `tags` | Tags aplicadas aos recursos | Nao |

## Outputs

- `role_name`, `role_arn`, `role_id`
- `policy_name`, `policy_arn`
- `policy_attachment_id`

## Validacao

```
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para rodar os comandos acima, pois nao ha chamadas a dados remotos da AWS.
