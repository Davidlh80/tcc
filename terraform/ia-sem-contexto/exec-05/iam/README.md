# IAM Role com Policy Anexada

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy dedicada anexada a ela. A policy nao fica solta: ela e criada e vinculada a role por meio de `aws_iam_role_policy_attachment`. A trust policy (assume role policy) da role e restrita aos principals informados em `trusted_principal_arns`, sem permitir `"*"` como principal.

## Recursos criados

- `aws_iam_role.this`: IAM Role com trust policy restrita a principals configurados.
- `aws_iam_policy.this`: IAM Policy com as actions e recursos configurados (sem wildcard `"*"` em actions).
- `aws_iam_role_policy_attachment.this`: anexa a policy criada a role criada.

## Boas praticas aplicadas

- A trust policy nao aceita `"*"` como principal (validado via `variable` `trusted_principal_arns`).
- A policy criada nao permite `actions = ["*"]` (validado via `variable` `allowed_actions`).
- Suporte opcional a `ExternalId` na trust policy para mitigar confused deputy (`require_external_id` e `external_id`).
- `max_session_duration` limitado ao intervalo permitido pela AWS (3600 a 43200 segundos).
- Tags aplicadas tanto na role quanto na policy via `var.tags`.
- Nenhum valor sensivel fixo no codigo; valores sensiveis (como `external_id`) sao passados via variavel marcada como `sensitive`.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name   = "app-execution-role"
  policy_name = "app-execution-policy"

  trusted_principal_arns = [
    "arn:aws:iam::123456789012:role/ci-cd-deployer"
  ]

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::minha-aplicacao-bucket",
    "arn:aws:s3:::minha-aplicacao-bucket/*"
  ]

  tags = {
    ambiente = "producao"
    projeto  = "minha-aplicacao"
  }
}
```

## Inputs principais

| Nome | Descricao | Tipo | Default |
|---|---|---|---|
| role_name | Nome da IAM Role | string | - |
| policy_name | Nome da IAM Policy | string | - |
| trusted_principal_arns | ARNs autorizados a assumir a role (sem `"*"`) | list(string) | - |
| allowed_actions | Actions permitidas pela policy (sem `"*"`) | list(string) | `["s3:GetObject", "s3:ListBucket"]` |
| allowed_resources | Recursos aos quais as actions se aplicam | list(string) | bucket de exemplo |
| require_external_id | Exige ExternalId na trust policy | bool | `false` |
| external_id | Valor do ExternalId (sensivel) | string | `""` |
| max_session_duration | Duracao maxima da sessao assumida em segundos | number | `3600` |
| tags | Tags aplicadas aos recursos | map(string) | `{}` |

## Outputs principais

| Nome | Descricao |
|---|---|
| role_arn | ARN da IAM Role criada |
| role_name | Nome da IAM Role criada |
| policy_arn | ARN da IAM Policy criada |
| policy_name | Nome da IAM Policy criada |
| role_policy_attachment_id | ID do attachment entre role e policy |

## Validacao

Este codigo foi escrito para ser validado localmente, sem backend remoto e sem credenciais reais:

```
terraform init -backend=false
terraform validate
```

Antes de aplicar em um ambiente real, revise `allowed_actions` e `allowed_resources` para garantir aderencia ao principio de menor privilegio no contexto especifico do seu workload.
