# IAM Role com IAM Policy Anexada

Blueprint Terraform para provisionar uma IAM Role e uma IAM Policy customer-managed anexada diretamente a ela via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela so existe atrelada a uma role com um trust policy (assume role) explicito.

## Recursos criados

- `aws_iam_role.this` — a role, com trust policy (assume role policy) construido dinamicamente a partir de `var.trusted_principals`.
- `aws_iam_policy.this` — a policy customer-managed, com statements definidos em `var.policy_statements`.
- `aws_iam_role_policy_attachment.this` — o vinculo entre a policy e a role.
- `data.aws_iam_policy_document.assume_role` e `data.aws_iam_policy_document.role_policy` — documentos JSON gerados de forma segura (evitam erros de sintaxe manual em JSON).

## Postura de seguranca adotada

- **Sem wildcard em actions/resources**: `var.policy_statements` possui validacoes que rejeitam `"*"` em `actions` e `resources`, forcando o consumidor do modulo a listar explicitamente o que e permitido.
- **Principal de confianca explicito**: o assume role policy so aceita os principals definidos em `var.trusted_principals` (por padrao, apenas o servico `ec2.amazonaws.com`). Nenhuma role e criada sem ao menos um principal de confianca.
- **Suporte a ExternalId**: quando `var.external_id` e definido, uma condicao `sts:ExternalId` e adicionada ao assume role policy — util para cenarios de acesso cross-account.
- **Permissions boundary opcional**: `var.permissions_boundary_arn` permite aplicar um boundary de permissoes, limitando o teto de privilegios da role.
- **Sem credenciais fixas**: nenhum valor sensivel e hardcoded; tudo e parametrizavel via variaveis.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name   = "minha-app-role"
  policy_name = "minha-app-policy"

  trusted_principals = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  ]

  policy_statements = [
    {
      sid        = "AllowReadSecrets"
      effect     = "Allow"
      actions    = ["secretsmanager:GetSecretValue"]
      resources  = ["arn:aws:secretsmanager:us-east-1:123456789012:secret:minha-app/*"]
      conditions = []
    }
  ]

  tags = {
    Environment = "production"
    Owner       = "time-plataforma"
  }
}
```

## Validacao

Este blueprint foi escrito para ser validado sem credenciais reais e sem backend remoto:

```
terraform init -backend=false
terraform validate
```

## Variaveis principais

| Variavel | Descricao | Default |
|---|---|---|
| `role_name` | Nome da IAM Role | `app-execution-role` |
| `policy_name` | Nome da IAM Policy | `app-execution-policy` |
| `trusted_principals` | Principals autorizados a assumir a role | Servico `ec2.amazonaws.com` |
| `external_id` | ExternalId exigido no assume role (opcional) | `null` |
| `permissions_boundary_arn` | ARN do permissions boundary (opcional) | `null` |
| `policy_statements` | Statements da policy anexada a role | Leitura em bucket S3 de exemplo |
| `max_session_duration` | Duracao maxima da sessao assumida (segundos) | `3600` |
| `tags` | Tags adicionais | `{}` |

## Outputs principais

- `role_arn`, `role_name`, `role_id`
- `policy_arn`, `policy_name`
- `role_policy_attachment_id`
