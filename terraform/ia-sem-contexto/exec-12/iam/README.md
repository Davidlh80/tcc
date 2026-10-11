# IAM Role com IAM Policy dedicada (Terraform)

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy
dedicada anexada a ela. A policy nunca fica solta: ela é criada e imediatamente
associada à role via `aws_iam_role_policy_attachment`.

## Recursos criados

- `aws_iam_role.this` — IAM Role com trust policy (assume role policy)
  restrita aos principals informados em `trusted_principal_arns`.
- `aws_iam_policy.this` — IAM Policy com permissões explícitas definidas por
  `allowed_actions` e `allowed_resources`.
- `aws_iam_role_policy_attachment.this` — Attachment que associa a policy à
  role.

## Decisões de segurança

- A trust policy (`data.aws_iam_policy_document.assume_role`) exige uma lista
  não vazia de ARNs de principals e rejeita explicitamente o wildcard `"*"`,
  evitando que qualquer conta ou principal possa assumir a role.
- É possível exigir um `external_id` na condição `sts:ExternalId` da trust
  policy, mitigando o problema de "confused deputy" em cenários de
  cross-account assume role.
- A policy de permissões rejeita o wildcard total `"*"` em `allowed_actions`
  e `allowed_resources`, forçando a declaração de ações e recursos
  específicos em vez de permissões administrativas amplas.
- `permissions_boundary_arn` permite anexar uma permissions boundary
  opcional à role, como camada adicional de contenção.
- Nenhum valor sensível ou credencial é hardcoded; todos os valores
  configuráveis são expostos como variáveis.

## Uso

```hcl
module "iam_role" {
  source = "./"

  role_name   = "app-read-only-role"
  policy_name = "app-read-only-policy"

  trusted_principal_arns = [
    "arn:aws:iam::111122223333:role/ci-deployer"
  ]

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
```

## Variáveis principais

| Nome                       | Descrição                                               | Obrigatória |
|----------------------------|----------------------------------------------------------|-------------|
| `role_name`                | Nome da IAM Role                                          | Sim         |
| `policy_name`               | Nome da IAM Policy                                        | Sim         |
| `trusted_principal_arns`   | ARNs autorizados a assumir a role (sem `"*"`)             | Sim         |
| `allowed_actions`          | Ações IAM permitidas (sem `"*"`)                          | Não         |
| `allowed_resources`        | ARNs de recursos permitidos (sem `"*"`)                   | Não         |
| `external_id`               | ExternalId exigido na trust policy                       | Não         |
| `permissions_boundary_arn` | ARN de permissions boundary opcional                      | Não         |
| `tags`                      | Tags aplicadas à role e à policy                          | Não         |

## Outputs

- `role_arn`, `role_id`, `role_name`
- `policy_arn`, `policy_id`, `policy_name`
- `attachment_id`

## Validação

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

Não é necessário backend remoto nem credenciais reais da AWS para executar
`init` e `validate`.
