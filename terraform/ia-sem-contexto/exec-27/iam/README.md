# IAM Role com Policy Anexada

Blueprint Terraform que provisiona uma IAM Policy e uma IAM Role na AWS, com a policy anexada diretamente a role (nunca ficando solta ou sem principal associado).

## Recursos criados

- `aws_iam_role.this`: role cuja trust policy (assume role policy) permite apenas que o principal definido em `trusted_principal_arn` execute `sts:AssumeRole`. Opcionalmente exige a condicao `sts:ExternalId`.
- `aws_iam_policy.this`: policy com permissoes restritas as actions e recursos definidos em `policy_actions` e `policy_resources`.
- `aws_iam_role_policy_attachment.this`: anexa a policy criada a role criada.

## Seguranca por padrao

- A trust policy nunca aceita `"*"` como principal; a variavel `trusted_principal_arn` possui validacao que rejeita esse valor e exige um ARN IAM valido.
- `policy_actions` rejeita wildcards amplos como `"*"` e `"iam:*"`, evitando permissoes administrativas.
- `policy_resources` rejeita `"*"` como recurso, reforcando o escopo minimo necessario.
- Suporte a `external_id` para mitigar o problema do confused deputy em cenarios cross-account.
- Tags configuraveis via `tags`, aplicadas tanto a role quanto a policy.

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `aws_region` | Regiao AWS do provider | `us-east-1` |
| `name_prefix` | Prefixo de nomenclatura da role/policy | `example` |
| `trusted_principal_arn` | ARN autorizado a assumir a role (obrigatorio) | - |
| `external_id` | ExternalId exigido na trust policy | `null` |
| `max_session_duration` | Duracao maxima de sessao (segundos) | `3600` |
| `policy_actions` | Actions permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Recursos alvo das actions | `["arn:aws:s3:::example-bucket/*"]` |
| `tags` | Tags aplicadas aos recursos | `{}` |

## Outputs principais

- `role_name`, `role_arn`, `role_id`
- `policy_name`, `policy_arn`
- `policy_attachment_id`

## Uso

```
module "iam_role" {
  source                 = "./"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-cd-deployer"
  policy_actions          = ["s3:GetObject", "s3:ListBucket"]
  policy_resources        = ["arn:aws:s3:::meu-bucket/*"]
  tags = {
    environment = "staging"
  }
}
```

## Validacao sintatica

```
terraform init -backend=false
terraform validate
```
