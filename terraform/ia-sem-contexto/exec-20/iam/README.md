# IAM Policy anexada a IAM Role

Blueprint Terraform que provisiona uma IAM Role e uma IAM Policy gerenciada,
anexando a policy a role via `aws_iam_role_policy_attachment`. A policy nunca
existe "solta": ela e sempre criada e anexada a um principal (a role) na mesma
aplicacao.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role) configuravel.
- `aws_iam_policy.this` — policy gerenciada com acoes e recursos explicitos.
- `aws_iam_role_policy_attachment.this` — vinculo entre a policy e a role.

## Decisoes de seguranca

- **Sem wildcard amplo**: `allowed_actions` e `resource_arns` rejeitam o valor
  `"*"` via `validation` nas variaveis. Toda acao e recurso deve ser declarado
  explicitamente.
- **Trust policy explicito**: o principal de confianca (`trusted_principal_type`
  e `trusted_principal_identifiers`) e definido pelo consumidor do modulo — nao
  ha default que confie em `"*"` ou em qualquer conta AWS.
- **External ID opcional**: quando `external_id` e informado, o trust policy
  exige a condicao `sts:ExternalId`, mitigando o problema do "confused deputy"
  em cenarios de acesso cross-account/terceiros.
- **MFA opcional**: `require_mfa = true` adiciona a condicao
  `aws:MultiFactorAuthPresent = true` ao assume role.
- **Permissions boundary opcional**: `permissions_boundary_arn` permite limitar
  o escopo maximo de permissoes da role.
- **Sem credenciais reais**: nenhum valor sensivel fixo e usado; tudo que e
  configuravel esta exposto como variavel.

## Uso

```hcl
module "iam_role_policy" {
  source = "./"

  role_name   = "meu-servico-role"
  policy_name = "meu-servico-policy"

  trusted_principal_type        = "Service"
  trusted_principal_identifiers = ["lambda.amazonaws.com"]

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject",
  ]

  resource_arns = [
    "arn:aws:s3:::meu-bucket/*",
  ]

  tags = {
    Environment = "production"
    Owner       = "time-plataforma"
  }
}
```

## Inputs principais

| Nome                             | Descricao                                           | Default                  |
|-----------------------------------|------------------------------------------------------|---------------------------|
| `role_name`                       | Nome da IAM Role                                     | `app-scoped-role`        |
| `policy_name`                     | Nome da IAM Policy                                   | `app-scoped-policy`      |
| `trusted_principal_type`          | Tipo do principal (`AWS`, `Service`, `Federated`)    | `Service`                 |
| `trusted_principal_identifiers`   | Identificadores do principal de confianca             | `["ec2.amazonaws.com"]`  |
| `external_id`                     | External ID exigido no assume role                    | `null`                    |
| `require_mfa`                     | Exige MFA para assumir a role                          | `false`                   |
| `allowed_actions`                 | Acoes IAM permitidas (sem `*`)                        | ver `variables.tf`        |
| `resource_arns`                   | Recursos alvo das acoes (sem `*`)                     | ver `variables.tf`        |
| `permissions_boundary_arn`        | ARN de permissions boundary                            | `null`                    |
| `tags`                            | Tags aplicadas a role e a policy                       | `{ ManagedBy = "terraform" }` |

## Outputs principais

- `role_arn`, `role_name`, `role_id`
- `policy_arn`, `policy_name`, `policy_id`
- `role_policy_attachment_id`

## Validacao local

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

Nenhum destes comandos requer credenciais AWS reais, pois nao ha backend
remoto nem chamadas de dados dependentes de uma conta especifica.
