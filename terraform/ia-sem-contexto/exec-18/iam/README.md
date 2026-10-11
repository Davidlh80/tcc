# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Policy anexada a uma IAM Role na AWS, com trust policy restrita a principal(is) configurável(is) e permissões escopadas (sem wildcards amplos).

## Recursos criados

- `aws_iam_role.this` — IAM Role com trust policy (`assume_role_policy`) restrita aos principals definidos em `var.trusted_principal_arns`.
- `aws_iam_policy.this` — IAM Policy com as actions e recursos definidos em `var.policy_actions` e `var.policy_resources`.
- `aws_iam_role_policy_attachment.this` — Anexa a policy à role, garantindo que a policy não fique solta sem principal associado.

## Decisões de segurança

- A trust policy nunca aceita `"*"` como principal: `var.trusted_principal_arns` exige ao menos um ARN explícito e rejeita o valor `"*"`.
- `var.policy_actions` e `var.policy_resources` rejeitam o valor `"*"`, evitando permissões administrativas implícitas e wildcards amplos.
- Nenhum valor sensível é fixado no código; todos os valores configuráveis são expostos via variáveis.
- Tags são aplicadas tanto na role quanto na policy, quando fornecidas.

## Uso

```hcl
module "iam_role_with_policy" {
  source = "./"

  role_name   = "app-read-only-role"
  policy_name = "app-read-only-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/trusted-ci-role"
  ]

  policy_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  policy_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Variáveis principais

| Nome | Descrição | Obrigatória |
|---|---|---|
| `role_name` | Nome da IAM Role | Sim |
| `policy_name` | Nome da IAM Policy | Sim |
| `trusted_principal_arns` | ARNs autorizados a assumir a role (sem `"*"`) | Sim |
| `policy_resources` | ARNs dos recursos alcançados pela policy (sem `"*"`) | Sim |
| `policy_actions` | Actions permitidas (sem `"*"`) | Não (default: leitura em S3) |
| `max_session_duration` | Duração máxima da sessão assumida | Não (default: 3600) |
| `tags` | Tags aplicadas aos recursos | Não (default: `{}`) |

## Outputs

| Nome | Descrição |
|---|---|
| `role_arn` | ARN da IAM Role |
| `role_name` | Nome da IAM Role |
| `role_unique_id` | Unique ID da IAM Role |
| `policy_arn` | ARN da IAM Policy |
| `policy_name` | Nome da IAM Policy |
| `policy_id` | ID da IAM Policy |
| `role_policy_attachment_id` | ID do attachment entre policy e role |

## Validação

```
terraform init -backend=false
terraform validate
```

Este módulo não usa backend remoto nem depende de credenciais reais para validação sintática.
