# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Policy anexada a uma IAM Role na AWS, com trust policy restrita a um principal configurável e permissões escopadas.

## Recursos criados

- `aws_iam_role.this` — Role com trust policy (assume role policy) restrita aos ARNs informados em `trusted_principal_arns`.
- `aws_iam_policy.this` — Policy com permissões definidas por `policy_actions` e `policy_resources`.
- `aws_iam_role_policy_attachment.this` — Anexa a policy à role, garantindo que ela nunca fique solta sem nenhum principal associado.

## Decisões de segurança

- A trust policy nunca aceita `"*"` como principal: a variável `trusted_principal_arns` exige ao menos um ARN IAM válido (conta `root`, `user/` ou `role/`) e rejeita qualquer valor que não corresponda a esse formato.
- `policy_actions` rejeita explicitamente a action `"*"`, evitando que a policy conceda permissão administrativa total.
- `policy_resources` exige ao menos um ARN explícito; recomenda-se evitar `"*"` sempre que o serviço de destino permitir escopo por recurso.
- Suporte opcional a `external_id` na trust policy para mitigar o problema do "confused deputy" em cenários de assume-role cross-account.
- Tags são aplicadas tanto na role quanto na policy via variável `tags`.

## Uso

```hcl
module "iam_role_policy" {
  source = "./"

  role_name   = "app-readonly-role"
  policy_name = "app-readonly-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/ci-deploy-role"
  ]

  policy_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  policy_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Variáveis principais

| Nome                     | Descrição                                                        | Obrigatória |
|--------------------------|--------------------------------------------------------------------|-------------|
| `role_name`              | Nome da IAM Role.                                                  | Sim         |
| `policy_name`            | Nome da IAM Policy.                                                | Sim         |
| `trusted_principal_arns` | ARNs autorizados a assumir a role (sem `"*"`).                     | Sim         |
| `policy_actions`         | Actions permitidas pela policy (sem `"*"`).                        | Sim         |
| `policy_resources`       | ARNs dos recursos alvo das actions.                                | Sim         |
| `external_id`            | ExternalId opcional para condition da trust policy.                | Não         |
| `max_session_duration`   | Duração máxima da sessão assumida (3600–43200s).                   | Não         |
| `tags`                   | Tags aplicadas à role e à policy.                                  | Não         |

## Outputs

- `role_arn`, `role_name`, `role_unique_id`
- `policy_arn`, `policy_id`, `policy_name`
- `role_policy_attachment_id`

## Validação

```bash
terraform init -backend=false
terraform validate
```

Não é necessário backend remoto nem credenciais reais da AWS para rodar `init` e `validate`, pois nenhum data source consulta a API da AWS em tempo de plan/validate.
