# IAM Role com IAM Policy anexada

Blueprint Terraform para provisionar uma IAM Role com uma IAM Policy dedicada
anexada a ela, seguindo o principio de menor privilegio.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role policy) restrita
  aos principals definidos em `trusted_principal_arns`. Nunca permite `"*"`
  como principal.
- `aws_iam_policy.this` — policy com as actions e recursos definidos em
  `allowed_actions` e `allowed_resources`. A action `"*"` (wildcard total) e
  bloqueada por validacao da variavel.
- `aws_iam_role_policy_attachment.this` — anexa a policy exclusivamente a
  role criada, garantindo que a policy nunca fique sem um principal
  associado.

## Uso

```
module "iam_role" {
  source = "./"

  region                  = "us-east-1"
  role_name               = "app-readonly-role"
  policy_name             = "app-readonly-policy"
  trusted_principal_arns  = ["arn:aws:iam::111111111111:role/ci-deployer"]
  external_id             = "optional-shared-secret-id"
  allowed_actions         = ["s3:GetObject", "s3:ListBucket"]
  allowed_resources       = ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]
  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

Ajuste `trusted_principal_arns`, `allowed_actions` e `allowed_resources`
para o caso de uso real antes de aplicar em um ambiente real.

## Variaveis principais

| Nome | Descricao | Default |
|---|---|---|
| `region` | Regiao AWS do provider | `us-east-1` |
| `role_name` | Nome da role | `example-app-role` |
| `policy_name` | Nome da policy | `example-app-policy` |
| `max_session_duration` | Duracao maxima de sessao (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `null` |
| `trusted_principal_arns` | Principals autorizados a assumir a role | `["arn:aws:iam::123456789012:root"]` |
| `external_id` | External ID opcional na trust policy | `""` |
| `allowed_actions` | Actions permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `allowed_resources` | Recursos alvo das actions | bucket de exemplo |
| `tags` | Tags aplicadas a role e policy | `{}` |

## Outputs

- `role_arn`, `role_name`, `role_unique_id`
- `policy_arn`, `policy_name`
- `policy_attachment_id`

## Seguranca

- A trust policy rejeita qualquer principal `"*"` (validado na variavel
  `trusted_principal_arns`).
- A policy rejeita a action wildcard total `"*"` (validado na variavel
  `allowed_actions`).
- Nenhuma permissao administrativa (`iam:*`, `*:*`) e concedida por
  padrao; o escopo de actions e recursos e definido explicitamente pelo
  consumidor do modulo.
- Nenhum valor sensivel (credenciais, segredos reais) e fixado no codigo.

## Validacao

```
terraform init -backend=false
terraform validate
```
