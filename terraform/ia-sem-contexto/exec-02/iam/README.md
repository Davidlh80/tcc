# IAM Policy — Blueprint Terraform

Blueprint autonoma para provisionar uma IAM Policy gerenciada pelo cliente (customer managed policy) na AWS, seguindo o principio de menor privilegio por padrao.

## Recursos criados

- `data.aws_iam_policy_document.this`: documento de politica montado dinamicamente a partir de `var.statements`.
- `aws_iam_policy.this`: IAM Policy gerenciada.

## Decisoes de seguranca

- Nenhum statement default permite `Resource = "*"`; validacoes em `variables.tf` bloqueiam wildcard isolado em `resources`.
- `effect` de cada statement e restrito a `Allow` ou `Deny` via validacao.
- Cada statement exige ao menos uma action e um resource explicitos.
- Nao ha valores sensiveis fixos nem dependencia de credenciais reais para `terraform validate`.

## Uso

```
terraform init -backend=false
terraform validate
terraform plan -var="aws_region=us-east-1"
```

Para customizar as permissoes, sobrescreva `statements` com os ARNs e actions desejados, por exemplo via arquivo `terraform.tfvars`:

```
statements = [
  {
    sid       = "AllowReadDynamoTable"
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:Query"]
    resources = ["arn:aws:dynamodb:us-east-1:123456789012:table/minha-tabela"]
  }
]
```

## Variaveis

| Nome          | Descricao                                         | Tipo                  | Default                  |
|---------------|----------------------------------------------------|------------------------|---------------------------|
| aws_region    | Regiao AWS utilizada pelo provider                 | string                 | "us-east-1"               |
| policy_name   | Nome da IAM Policy                                 | string                 | "app-custom-policy"       |
| path          | Path da IAM Policy no IAM                          | string                 | "/"                       |
| description   | Descricao da IAM Policy                            | string                 | ver `variables.tf`        |
| statements    | Lista de statements (sid, effect, actions, resources) | list(object)        | statement de exemplo em S3 |
| tags          | Tags aplicadas ao recurso                          | map(string)            | { ManagedBy = "terraform" } |

## Outputs

| Nome         | Descricao                          |
|--------------|-------------------------------------|
| policy_arn   | ARN da IAM Policy criada            |
| policy_id    | ID da IAM Policy criada             |
| policy_name  | Nome da IAM Policy criada           |
| policy_path  | Path da IAM Policy criada           |

## Observacoes

Esta blueprint nao anexa a policy a nenhuma role, user ou group — o attachment deve ser feito por outro modulo/recurso conforme a necessidade de cada ambiente.
