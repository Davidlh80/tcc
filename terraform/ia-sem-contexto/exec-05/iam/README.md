# IAM Policy anexada a IAM Role

Blueprint Terraform que provisiona uma IAM Role com trust policy explicita e uma IAM Policy com permissoes explicitas, anexada diretamente a essa role via `aws_iam_role_policy_attachment`. A policy nunca fica solta: o attachment e um recurso obrigatorio do modulo.

## O que este blueprint cria

- `aws_iam_role.this`: role com `assume_role_policy` gerado a partir de `data.aws_iam_policy_document.assume_role`, aceitando service principals e/ou account principals (cross-account), com suporte opcional a `sts:ExternalId`.
- `aws_iam_policy.this`: policy gerada a partir de `data.aws_iam_policy_document.permissions`, com statements definidos via `var.policy_statements`.
- `aws_iam_role_policy_attachment.this`: vincula a policy a role.

## Decisoes de seguranca por padrao

- Nenhum principal coringa (`*`) e aceito na trust policy; e obrigatorio informar ao menos um service principal ou account principal (validado via `precondition` na role).
- `policy_statements` bloqueia `actions` e `resources` com valor `"*"` (validado via `validation` na variavel), forcando o autor a listar permissoes explicitas.
- Suporte a `permissions_boundary_arn` para reforcar o principio de menor privilegio.
- `assume_role_account_principals` (cross-account) vazio por padrao; quando usado, recomenda-se preencher `external_id` para mitigar o problema do "confused deputy".
- Tags padrao (`ManagedBy = "terraform"`) aplicadas automaticamente, alem das tags informadas em `var.tags`.

## Uso basico

```hcl
module "iam_role_policy" {
  source = "./"

  role_name   = "app-service-role"
  policy_name = "app-service-policy"

  assume_role_service_principals = ["ec2.amazonaws.com"]

  policy_statements = [
    {
      sid       = "AllowS3ReadOnly"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::meu-bucket",
        "arn:aws:s3:::meu-bucket/*"
      ]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Cross-account (assume role por outra conta)

```hcl
assume_role_service_principals  = []
assume_role_account_principals  = ["arn:aws:iam::111111111111:root"]
external_id                     = "um-valor-secreto-combinado"
```

## Validacao local

```
terraform init -backend=false
terraform validate
```

Nao e necessario backend remoto nem credenciais reais para validar a sintaxe; apenas `apply` exige credenciais AWS validas.

## Principais variaveis

| Nome | Descricao | Default |
|---|---|---|
| `role_name` / `policy_name` | Nomes da role e da policy | `app-service-role` / `app-service-policy` |
| `path` | Path IAM aplicado a role e policy | `/` |
| `assume_role_service_principals` | Services autorizados a assumir a role | `["ec2.amazonaws.com"]` |
| `assume_role_account_principals` | ARNs de contas/roles externos autorizados | `[]` |
| `external_id` | External ID para cross-account | `null` |
| `max_session_duration` | Duracao maxima da sessao (segundos) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary | `null` |
| `policy_statements` | Lista de statements da policy | statement de exemplo (S3 read-only) |
| `tags` | Tags adicionais | `{}` |

## Outputs

- `role_arn`, `role_name`, `role_unique_id`
- `policy_arn`, `policy_name`
- `policy_attachment_id`
