# IAM Role com IAM Policy Anexada

Blueprint Terraform para provisionar uma IAM Role na AWS com uma IAM Policy dedicada, anexada via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e criada e anexada a role no mesmo modulo.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role policy) configuravel.
- `aws_iam_policy.this` — policy gerenciada com acoes e recursos explicitos (sem wildcards).
- `aws_iam_role_policy_attachment.this` — vinculo entre a policy e a role.

## Design de seguranca

- **Sem wildcards**: `policy_actions` e `policy_resources` rejeitam o valor `"*"` via `validation` em `variables.tf`. Defina explicitamente as acoes e os ARNs necessarios.
- **Trust policy explicita**: o assume role policy aceita dois mecanismos, combinaveis:
  - `trusted_service_principals`: lista de service principals AWS (ex.: `ec2.amazonaws.com`, `lambda.amazonaws.com`). Default: `["ec2.amazonaws.com"]`.
  - `trusted_account_arns`: lista de ARNs de contas, roles ou usuarios para cenarios cross-account. Quando usado junto com `external_id`, a condicao `sts:ExternalId` e aplicada automaticamente para mitigar o problema do "confused deputy".
- **Permissions boundary opcional**: defina `permissions_boundary_arn` para aplicar um limite adicional de permissoes a role.
- **Duracao de sessao limitada**: `max_session_duration` e validado entre 3600 e 43200 segundos (limites da AWS).
- **Tags de rastreabilidade**: todas as tags informadas em `var.tags` sao mescladas com `ManagedBy = "terraform"`.

## Uso

```hcl
module "iam_role" {
  source = "./"

  role_name   = "minha-app-role"
  policy_name = "minha-app-policy"

  trusted_service_principals = ["lambda.amazonaws.com"]

  policy_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  policy_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  tags = {
    Ambiente = "dev"
  }
}
```

### Cenario cross-account com External ID

```hcl
trusted_service_principals = []
trusted_account_arns       = ["arn:aws:iam::111122223333:root"]
external_id                = "um-valor-secreto-unico"
```

## Inputs principais

| Nome | Descricao | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | `app-role` |
| `policy_name` | Nome da IAM Policy | `app-policy` |
| `trusted_service_principals` | Service principals autorizados a assumir a role | `["ec2.amazonaws.com"]` |
| `trusted_account_arns` | ARNs autorizados a assumir a role (cross-account) | `[]` |
| `external_id` | External ID exigido para assume role cross-account | `""` |
| `policy_actions` | Acoes permitidas pela policy (sem `*`) | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Recursos permitidos pela policy (sem `*`) | ver `variables.tf` |
| `max_session_duration` | Duracao maxima da sessao assumida (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary | `""` |
| `tags` | Tags adicionais | `{}` |

Veja `variables.tf` para a lista completa de inputs e `outputs.tf` para os outputs disponiveis.

## Validacao local

```bash
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e nenhuma credencial real da AWS sao necessarios para essas etapas, pois os recursos e data sources utilizados (`aws_iam_role`, `aws_iam_policy`, `aws_iam_policy_document`) nao dependem de chamadas de API para validacao sintatica.
