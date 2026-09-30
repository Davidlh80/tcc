# IAM Role + IAM Policy (Terraform)

Blueprint Terraform para provisionar uma IAM Role e uma IAM Policy customizada anexada a ela via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e sempre criada em conjunto com a role e o attachment neste mesmo modulo.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role policy) restrita a um principal de servico AWS configuravel, com suporte opcional a condicao `sts:ExternalId`.
- `aws_iam_policy.this` — policy gerenciada pelo cliente (customer managed policy) com acoes e recursos definidos via variaveis.
- `aws_iam_role_policy_attachment.this` — vincula a policy criada a role criada.

## Principios de seguranca adotados

- **Menor privilegio por padrao**: as variaveis `policy_actions` e `policy_resources` vem com exemplos restritos (sem uso de `Action = "*"` ou `Resource = "*"`). Ajuste esses valores para o minimo necessario ao caso de uso real.
- **Trust policy explicita**: apenas o principal informado em `trusted_principal_service` pode assumir a role. Nao ha `Principal = "*"`.
- **Suporte a External ID**: para cenarios de assume role entre contas ou por terceiros, defina `external_id` para adicionar a condicao `sts:ExternalId` no trust policy.
- **Sem valores sensiveis fixos**: nenhum ARN de conta, chave ou credencial real esta hard-coded. Os ARNs de exemplo em `policy_resources` sao placeholders (`REPLACE_WITH_BUCKET_NAME`) que devem ser substituidos.
- **Tags padronizadas**: todos os recursos recebem tags base (`ManagedBy`, `Component`) combinadas com as tags customizadas fornecidas em `tags`.

## Uso

```hcl
module "iam_role_policy" {
  source = "./"

  role_name   = "minha-app-role"
  policy_name = "minha-app-policy"

  trusted_principal_service = "lambda.amazonaws.com"

  policy_actions = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  policy_resources = [
    "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/minha-app:*",
  ]

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default |
|---|---|---|---|
| `aws_region` | Regiao AWS usada pelo provider | `string` | `"us-east-1"` |
| `role_name` | Nome da IAM Role | `string` | `"app-execution-role"` |
| `role_description` | Descricao da IAM Role | `string` | ver `variables.tf` |
| `policy_name` | Nome da IAM Policy | `string` | `"app-execution-policy"` |
| `policy_description` | Descricao da IAM Policy | `string` | ver `variables.tf` |
| `trusted_principal_service` | Principal de servico AWS autorizado a assumir a role | `string` | `"ec2.amazonaws.com"` |
| `external_id` | External ID opcional para a condicao `sts:ExternalId` | `string` | `null` |
| `max_session_duration` | Duracao maxima da sessao assumida (segundos) | `number` | `3600` |
| `policy_actions` | Acoes IAM permitidas pela policy | `list(string)` | exemplo de acoes de leitura em S3 |
| `policy_resources` | ARNs alvo das acoes permitidas | `list(string)` | placeholders de bucket S3 |
| `tags` | Tags adicionais para os recursos | `map(string)` | `{}` |

## Outputs

| Nome | Descricao |
|---|---|
| `role_arn` | ARN da IAM Role criada |
| `role_name` | Nome da IAM Role criada |
| `role_id` | ID unico da IAM Role criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_attachment_id` | ID do attachment entre policy e role |

## Validacao local

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para `init`/`validate`, pois nao ha backend remoto configurado e nenhum recurso depende de chamadas a API durante essas etapas.
