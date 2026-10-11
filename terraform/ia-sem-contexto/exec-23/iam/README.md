# IAM Role com IAM Policy Anexada

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy dedicada anexada a ela, seguindo boas práticas de segurança por padrão.

## O que este módulo cria

- Uma `aws_iam_policy` com permissões restritas às ações e recursos configurados (sem `"*"` em ações administrativas por padrão).
- Uma `aws_iam_role` cuja trust policy (`assume_role_policy`) permite `sts:AssumeRole` **apenas** para os principais informados em `trusted_principal_arns` — nunca para `"*"` ou `AWS: "*"`.
- Um `aws_iam_role_policy_attachment` associando a policy à role, garantindo que a policy não fique solta sem nenhum principal associado.

## Decisões de segurança

- A trust policy exige uma lista não vazia de ARNs confiáveis (`trusted_principal_arns`) e rejeita explicitamente `"*"` via `validation` na variável.
- `allowed_actions` rejeita a ação wildcard `"*"` e a ação administrativa `"iam:*"` via `validation`.
- É possível exigir um `external_id` (condição `sts:ExternalId`) para mitigar o problema de *confused deputy* ao assumir a role entre contas.
- Suporte opcional a `permissions_boundary_arn` para limitar o escopo máximo de permissões da role.
- Tags são aplicadas tanto à role quanto à policy via a variável `tags`.

## Uso

```hcl
module "iam_role_policy" {
  source = "./"

  role_name   = "app-readonly-role"
  policy_name = "app-readonly-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/ci-deployer",
  ]

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::my-app-bucket",
    "arn:aws:s3:::my-app-bucket/*",
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Inputs principais

| Nome                       | Descrição                                                      | Padrão              |
| --------------------------- | ---------------------------------------------------------------- | -------------------- |
| `role_name`                 | Nome da IAM Role                                                  | —                     |
| `policy_name`               | Nome da IAM Policy                                                | —                     |
| `trusted_principal_arns`    | ARNs permitidos a assumir a role (não aceita `"*"`)              | —                     |
| `allowed_actions`           | Ações IAM permitidas (não aceita `"*"` ou `iam:*`)                | ações de leitura S3   |
| `allowed_resources`         | ARNs dos recursos alvo das ações permitidas                      | bucket S3 de exemplo  |
| `external_id`               | External ID exigido na trust policy                               | `null`                |
| `permissions_boundary_arn`  | ARN de permissions boundary aplicada à role                      | `null`                |
| `max_session_duration`      | Duração máxima da sessão assumida (segundos)                     | `3600`                |
| `tags`                      | Tags aplicadas à role e à policy                                  | `{}`                  |

## Outputs principais

| Nome            | Descrição                        |
| ---------------- | ----------------------------------- |
| `role_arn`        | ARN da IAM Role criada              |
| `role_name`       | Nome da IAM Role criada             |
| `policy_arn`      | ARN da IAM Policy criada            |
| `policy_name`     | Nome da IAM Policy criada           |
| `attachment_id`   | ID do attachment role/policy        |

## Validação

Este módulo foi escrito para ser validado sem credenciais reais e sem backend remoto:

```bash
terraform init -backend=false
terraform validate
```
