# IAM Policy anexada a IAM Role

Blueprint Terraform que provisiona uma IAM Role com trust policy restrita a um principal configuravel e uma IAM Policy com permissoes especificas, anexada a essa role via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e criada e anexada na mesma aplicacao.

## Recursos criados

- `aws_iam_role.this` — role com assume role policy (trust policy) restrita.
- `aws_iam_policy.this` — policy com acoes e recursos definidos por variavel.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.
- `data.aws_iam_policy_document.assume_role` — gera a trust policy a partir de `trust_principal_type` e `trust_principal_identifiers`.
- `data.aws_iam_policy_document.permissions` — gera a policy de permissoes a partir de `allowed_actions` e `resource_arns`.

## Decisoes de seguranca

- A trust policy exige `trust_principal_identifiers` explicitos e bloqueia o uso de `"*"` como principal, evitando que qualquer conta ou entidade assuma a role.
- `allowed_actions` bloqueia os wildcards `"*"` e `"*:*"`, evitando permissoes administrativas totais por acidente. Os valores default sao de exemplo (leitura em um bucket S3) e devem ser ajustados para o caso de uso real.
- `resource_arns` bloqueia o wildcard global `"*"`, exigindo ARNs explicitos ou padroes escopados (ex: `arn:aws:s3:::bucket/*`).
- Nenhum valor sensivel (credenciais, segredos) e usado ou exigido para `terraform validate`.

## Uso

```
terraform init -backend=false
terraform validate
```

Para aplicar de fato, defina ao menos `trust_principal_identifiers` com o(s) principal(is) real(is) autorizados a assumir a role, e ajuste `allowed_actions` / `resource_arns` conforme o escopo necessario.

## Variaveis principais

| Nome | Descricao | Default |
|---|---|---|
| `aws_region` | Regiao AWS do provider | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-restricted-role` |
| `role_path` | Path da role (inicia/termina com `/`) | `/` |
| `max_session_duration` | Duracao maxima de sessao (segundos) | `3600` |
| `trust_principal_type` | Tipo de principal (`AWS`, `Service`, `Federated`) | `AWS` |
| `trust_principal_identifiers` | Principals autorizados a assumir a role (sem `"*"`) | `["arn:aws:iam::123456789012:root"]` |
| `policy_name` | Nome da IAM Policy | `app-restricted-policy` |
| `allowed_actions` | Acoes permitidas (sem `"*"`/`"*:*"`) | `["s3:GetObject", "s3:ListBucket"]` |
| `resource_arns` | Recursos alvo das acoes (sem `"*"`) | bucket S3 de exemplo |
| `tags` | Tags aplicadas a role e policy | `{}` |

## Outputs

- `role_name`, `role_arn`, `role_id`, `role_unique_id`
- `policy_name`, `policy_arn`, `policy_id`
- `role_policy_attachment_id`
