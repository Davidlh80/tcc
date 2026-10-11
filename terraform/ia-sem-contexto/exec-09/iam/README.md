# IAM Role com IAM Policy anexada

## Visao geral

Este modulo provisiona:

- Uma IAM Policy com um conjunto configuravel de actions e resources (sem wildcard `*` e sem actions administrativas de IAM).
- Uma IAM Role cuja trust policy (assume role policy) restringe quais principals (`AWS:`) podem executar `sts:AssumeRole`, nunca permitindo `*`.
- O attachment entre a IAM Policy e a IAM Role, garantindo que a policy nunca fique solta sem um principal associado.

## Recursos criados

- `aws_iam_role.this`
- `aws_iam_policy.this`
- `aws_iam_role_policy_attachment.this`
- `data.aws_iam_policy_document.assume_role`
- `data.aws_iam_policy_document.permissions`

## Pre-requisitos

- Terraform >= 1.5.0
- Provider `hashicorp/aws` ~> 5.0
- Credenciais AWS configuradas apenas para `apply` (nao sao necessarias para `terraform validate`)

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name   = "payment-service-role"
  policy_name = "payment-service-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/ci-cd-deployer"
  ]

  external_id = "optional-shared-secret"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  tags = {
    Environment = "production"
    Owner       = "team-payments"
  }
}
```

## Inputs principais

| Nome                        | Descricao                                                                 | Default                     |
|-----------------------------|-----------------------------------------------------------------------------|------------------------------|
| `aws_region`                | Regiao AWS do provider                                                      | `us-east-1`                 |
| `role_name`                 | Nome da IAM Role                                                            | `app-restricted-role`       |
| `trusted_principal_arns`    | ARNs autorizados a assumir a role (obrigatorio, nunca `*`)                  | —                            |
| `external_id`                | ExternalId opcional para mitigar confused deputy                            | `null`                       |
| `permissions_boundary_arn`  | ARN opcional de permissions boundary                                        | `null`                       |
| `policy_name`                | Nome da IAM Policy                                                          | `app-restricted-policy`     |
| `allowed_actions`            | Actions permitidas pela policy (sem `*` e sem actions administrativas IAM) | `["s3:GetObject", "s3:ListBucket"]` |
| `allowed_resources`          | Recursos/ARNs alvo das actions (obrigatorio, nunca `*`)                     | —                            |
| `tags`                        | Tags aplicadas a role e a policy                                            | `{}`                          |

## Outputs

| Nome                     | Descricao                                        |
|---------------------------|---------------------------------------------------|
| `role_name`               | Nome da IAM Role criada                           |
| `role_arn`                 | ARN da IAM Role criada                            |
| `role_unique_id`          | ID unico da IAM Role                              |
| `policy_name`              | Nome da IAM Policy criada                         |
| `policy_arn`               | ARN da IAM Policy criada                          |
| `policy_attachment_id`    | ID do attachment entre policy e role              |

## Consideracoes de seguranca

- A trust policy nunca aceita `"*"` como principal; `trusted_principal_arns` e validado para rejeitar esse valor e exigir ARNs IAM validos.
- A policy criada nao concede permissoes administrativas amplas: `allowed_actions` rejeita `*`, wildcards no formato `servico:*` e actions administrativas de IAM (`iam:Create*`, `iam:Attach*`, `iam:Put*`, `iam:Delete*`, `iam:Update*`).
- `allowed_resources` rejeita o wildcard amplo `*`, forcando a especificacao de ARNs ou prefixos concretos.
- A policy e sempre anexada a uma role via `aws_iam_role_policy_attachment`, nunca ficando sem um principal associado.
- Use `external_id` quando o principal confiavel for de terceiros, para reduzir o risco de confused deputy.
- Nenhum valor sensivel ou credencial e definido no codigo; todos os valores configuraveis sao expostos via variaveis.
