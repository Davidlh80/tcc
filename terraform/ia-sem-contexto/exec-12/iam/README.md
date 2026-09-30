# IAM Role + IAM Policy (Terraform)

Blueprint Terraform, sem vinculo a padroes organizacionais especificos, para provisionar uma IAM Role na AWS com uma IAM Policy dedicada anexada a ela via `aws_iam_role_policy_attachment`. A policy nunca fica solta: o modulo falha na validacao (`lifecycle.precondition`) se nenhum principal confiavel for definido para o assume role.

## Recursos criados

- `aws_iam_role.this` — role com trust policy configuravel.
- `aws_iam_policy.this` — policy gerenciada com as permissoes definidas pelo consumidor.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.
- `data.aws_iam_policy_document.assume_role` — trust policy (assume role) construida a partir de `trusted_service_principals` e/ou `trusted_account_principals`.
- `data.aws_iam_policy_document.role_policy` — statement de permissoes construida a partir de `policy_actions` e `policy_resources`.

## Principal de confianca (assume role)

O trust policy e montado dinamicamente:

- `trusted_service_principals`: servicos AWS (ex.: `ec2.amazonaws.com`, `lambda.amazonaws.com`) que podem assumir a role.
- `trusted_account_principals`: ARNs de contas/entidades IAM que podem assumir a role via `sts:AssumeRole`.
- `external_id` (opcional, sensitive): adiciona a condicao `sts:ExternalId` na statement de principals de conta — recomendado para acesso cross-account de terceiros.

Pelo menos uma das duas listas de principals deve ser informada; caso contrario, o `terraform plan`/`apply` falha explicitamente.

## Permissoes (least privilege por padrao)

- `policy_actions` e `policy_resources` sao obrigatorios e nao aceitam listas vazias.
- O uso de `"*"` em `policy_actions` ou `policy_resources` e bloqueado por padrao. Para permitir explicitamente (nao recomendado em producao), defina `allow_wildcard_actions = true` e/ou `allow_wildcard_resources = true`.
- `policy_effect` aceita `Allow` ou `Deny` (default `Allow`).

## Exemplo de uso

```hcl
module "app_role" {
  source = "./"

  role_name   = "app-service-role"
  policy_name = "app-service-policy"

  trusted_service_principals = ["ec2.amazonaws.com"]

  policy_actions = [
    "s3:GetObject",
    "s3:PutObject"
  ]

  policy_resources = [
    "arn:aws:s3:::exemplo-bucket/*"
  ]

  tags = {
    Environment = "dev"
    Owner       = "team-plataforma"
  }
}
```

## Principais variaveis

| Nome | Descricao | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | (obrigatorio) |
| `policy_name` | Nome da IAM Policy | (obrigatorio) |
| `trusted_service_principals` | Servicos autorizados a assumir a role | `[]` |
| `trusted_account_principals` | ARNs autorizados a assumir a role | `[]` |
| `external_id` | External ID para assume role cross-account | `null` |
| `max_session_duration` | Duracao maxima da sessao (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary | `null` |
| `policy_actions` | Actions da policy | (obrigatorio) |
| `policy_resources` | Recursos da policy | (obrigatorio) |
| `allow_wildcard_actions` / `allow_wildcard_resources` | Libera uso de `"*"` | `false` |
| `tags` | Tags adicionais | `{}` |

## Outputs

`role_arn`, `role_name`, `role_id`, `policy_arn`, `policy_id`, `policy_name`, `policy_attachment_id`.

## Validacao local

```bash
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para `init`/`validate`. Nao ha backend remoto configurado.
