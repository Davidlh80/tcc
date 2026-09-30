# IAM Role com Policy Gerenciada Anexada

Blueprint Terraform para provisionar uma IAM Role e uma IAM Policy gerenciada,
anexadas entre si via `aws_iam_role_policy_attachment`. A policy nunca fica
solta: ela sempre e criada junto com o attachment para a role definida neste
mesmo modulo.

## Decisoes de seguranca

- **Sem wildcards por padrao**: `allowed_actions` e `resource_arns` sao listas
  explicitas e ha validacoes que impedem o uso do wildcard `"*"` isolado em
  qualquer uma delas.
- **Trust policy explicita**: a `assume_role_policy` e construida via
  `data.aws_iam_policy_document`, aceitando apenas os service principals
  informados em `trusted_service_principals`. Nao ha suporte, por padrao, a
  contas externas ou usuarios arbitrarios como principal.
- **Duracao de sessao limitada**: `max_session_duration` e restrita entre 1h e
  12h (limites da AWS), evitando sessoes assumidas por tempo indefinido.
- **Nomenclatura validada**: `role_name` e `policy_name` sao validados contra o
  padrao de caracteres aceitos pela AWS para recursos IAM.

## Uso

```hcl
module "app_role" {
  source = "./"

  role_name   = "minha-app-role"
  policy_name = "minha-app-policy"

  trusted_service_principals = ["lambda.amazonaws.com"]

  allowed_actions = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
  ]

  resource_arns = [
    "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/minha-app:*",
  ]

  tags = {
    Environment = "producao"
    Owner       = "time-plataforma"
  }
}
```

## Variaveis principais

| Nome                         | Descricao                                              | Default                          |
|------------------------------|---------------------------------------------------------|-----------------------------------|
| `aws_region`                  | Regiao AWS                                              | `us-east-1`                       |
| `role_name`                   | Nome da IAM Role                                        | `app-execution-role`              |
| `policy_name`                 | Nome da IAM Policy                                      | `app-least-privilege-policy`      |
| `trusted_service_principals`  | Service principals autorizados a assumir a role         | `["ec2.amazonaws.com"]`           |
| `allowed_actions`             | Actions permitidas pela policy                          | `["s3:GetObject", "s3:ListBucket"]` |
| `resource_arns`               | ARNs de recursos cobertos pela policy                   | ver `variables.tf`                |
| `max_session_duration`        | Duracao maxima de sessao (segundos)                     | `3600`                            |
| `tags`                        | Tags aplicadas aos recursos                             | `{ ManagedBy = "terraform" }`     |

## Outputs

- `role_arn`, `role_name`, `role_id`
- `policy_arn`, `policy_name`, `policy_id`
- `role_policy_attachment_id`

## Validacao local

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e nenhuma credencial real sao necessarios para essas
validacoes sintaticas.
