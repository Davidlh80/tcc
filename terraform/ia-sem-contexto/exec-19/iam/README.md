# IAM Role com Policy Anexada

Blueprint Terraform para provisionar uma IAM Role e uma IAM Policy customizada, anexada exclusivamente a essa role via `aws_iam_role_policy_attachment`. A policy nunca permanece solta, sem nenhum principal associado.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role policy) restrita a um unico principal configuravel.
- `aws_iam_policy.this` — policy com permissoes escopadas (sem wildcard amplo e sem permissoes administrativas).
- `aws_iam_role_policy_attachment.this` — anexa a policy a role criada.

## Segurança por padrão

- A trust policy aceita apenas o ARN configurado em `trusted_principal_arn`. O uso de `"*"` ou de um ARN genérico é bloqueado por validação da variável.
- Suporte opcional a `sts:ExternalId` via `external_id`, útil em cenários de acesso cross-account por terceiros.
- `policy_actions` e `policy_resources` possuem validação que impede listas vazias ou o uso de `"*"`, reduzindo o risco de permissões amplas ou administrativas por descuido.
- Nenhum valor sensível é fixado no código; tudo é parametrizado via variáveis.

## Uso

```hcl
module "iam_role_policy" {
  source = "./"

  role_name             = "app-service-role"
  policy_name           = "app-service-policy"
  trusted_principal_arn = "arn:aws:iam::123456789012:role/ci-cd-pipeline"

  policy_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  policy_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*",
  ]

  tags = {
    Environment = "staging"
    Owner       = "time-plataforma"
  }
}
```

## Inputs principais

| Nome                     | Descrição                                                        | Default            |
| ------------------------- | ------------------------------------------------------------------ | ------------------- |
| `aws_region`              | Região do provider AWS                                            | `us-east-1`          |
| `role_name`               | Nome da IAM Role                                                   | `example-role`       |
| `policy_name`             | Nome da IAM Policy                                                 | `example-policy`     |
| `trusted_principal_arn`   | ARN do principal autorizado a assumir a role (obrigatório, sem `*`) | —                    |
| `external_id`             | ExternalId opcional na assume role policy                        | `null`                |
| `max_session_duration`    | Duração máxima da sessão assumida (segundos)                      | `3600`                |
| `policy_actions`          | Actions permitidas pela policy (sem `*`)                          | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources`        | Recursos aos quais as actions se aplicam (sem `*`)                | `["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]` |
| `tags`                    | Tags aplicadas à role e à policy                                  | `{}`                  |

## Outputs

- `role_name`, `role_arn`, `role_id`, `role_unique_id`
- `policy_name`, `policy_arn`, `policy_id`

## Validação

```bash
terraform init -backend=false
terraform validate
```

Nenhum backend remoto é configurado e nenhuma credencial real é necessária para validação sintática.
