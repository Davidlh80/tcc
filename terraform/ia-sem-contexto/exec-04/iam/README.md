# IAM Role + IAM Policy (Terraform)

Blueprint Terraform para provisionar uma **IAM Role** com uma **IAM Policy** gerenciada dedicada, anexada via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e criada e anexada ao mesmo principal (a role) na mesma execucao.

## Recursos criados

- `aws_iam_role.this` — role com trust policy (assume role) configuravel.
- `aws_iam_policy.this` — policy gerenciada com statements definidos por variavel.
- `aws_iam_role_policy_attachment.this` — anexa a policy a role.
- `data.aws_iam_policy_document.assume_role` — gera o trust policy.
- `data.aws_iam_policy_document.this` — gera o documento da policy de permissoes.
- `data.aws_caller_identity.current` — usado apenas para enriquecer a descricao da policy.

## Seguranca por padrao

- O principal de confianca (`assume_role_principal_identifiers`) nao pode ser `*` (validado por `variable.validation`).
- Os statements da policy (`policy_statements`) exigem `effect` explicito (`Allow`/`Deny`) e sao definidos individualmente por acao/recurso — nenhum wildcard de recurso e forcado pelo modulo; o padrao entregue restringe as acoes a `logs:CreateLogGroup`, `logs:CreateLogStream` e `logs:PutLogEvents` sobre um prefixo especifico de log group.
- `permissions_boundary_arn` permite aplicar uma permissions boundary opcional.
- `assume_role_external_id` permite exigir External ID para cenarios de assume role entre contas.
- Nenhum valor sensivel ou credencial e usado; toda configuracao e parametrizada via variaveis.

## Uso

```hcl
module "iam_role" {
  source = "./"

  role_name   = "orders-service-role"
  policy_name = "orders-service-policy"

  assume_role_principal_type        = "Service"
  assume_role_principal_identifiers = ["lambda.amazonaws.com"]

  policy_statements = [
    {
      sid       = "AllowReadOrdersBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::orders-bucket",
        "arn:aws:s3:::orders-bucket/*"
      ]
    }
  ]

  tags = {
    Environment = "production"
    Owner       = "orders-team"
  }
}
```

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `aws_region` | Regiao AWS do provider | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-execution-role` |
| `policy_name` | Nome da IAM Policy | `app-execution-policy` |
| `assume_role_principal_type` | Tipo do principal de confianca | `Service` |
| `assume_role_principal_identifiers` | Identificadores do principal (sem `*`) | `["lambda.amazonaws.com"]` |
| `assume_role_external_id` | External ID opcional | `null` |
| `max_session_duration` | Duracao maxima da sessao (s) | `3600` |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | `null` |
| `policy_statements` | Lista de statements da policy | ver `variables.tf` |
| `tags` | Tags adicionais | `{}` |

## Outputs

- `role_arn`, `role_name`, `role_id`, `role_unique_id`
- `policy_arn`, `policy_name`
- `policy_attachment_id`

## Validacao local

```bash
terraform init -backend=false
terraform validate
```

Nenhum backend remoto ou credencial real e necessario para essas verificacoes, pois todos os valores possuem defaults seguros e nenhuma chamada de API e feita em `validate`.
