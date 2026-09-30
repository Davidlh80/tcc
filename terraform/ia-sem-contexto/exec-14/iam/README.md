# IAM Policy anexada a IAM Role

Blueprint Terraform independente (sem contexto organizacional) para provisionar uma IAM Role e uma IAM Policy de privilegio minimo anexada a ela via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e sempre criada e anexada a uma role na mesma execucao.

## O que este blueprint cria

- `aws_iam_role.this`: role com trust policy (assume role) restrita aos service principals informados em `assume_role_service_principals`.
- `aws_iam_policy.this`: policy gerenciada composta pelos statements definidos em `policy_statements`.
- `aws_iam_role_policy_attachment.this`: anexa a policy criada diretamente a role criada.

## Decisoes de seguranca por padrao

- O principal de confianca (trust policy) e sempre um `Service` da AWS, nunca `"*"` — a variavel `assume_role_service_principals` rejeita explicitamente o valor `"*"`.
- Suporte opcional a `sts:ExternalId` via `assume_role_external_id`, util para cenarios cross-account.
- A policy anexada nao aceita `resources = ["*"]` em nenhum statement (validado via `validation` na variavel `policy_statements`), forcando escopo explicito de recursos.
- `max_session_duration` limitado ao intervalo permitido pela AWS (3600–43200 segundos).
- Suporte opcional a `permissions_boundary_arn` para reforcar o teto de privilegios da role.
- Nenhum valor sensivel ou credencial fixa no codigo; tudo e parametrizado via variaveis.

## Uso

```
module "iam_role_policy" {
  source = "./"

  role_name   = "minha-app-role"
  policy_name = "minha-app-policy"

  assume_role_service_principals = ["lambda.amazonaws.com"]

  policy_statements = [
    {
      sid       = "AllowReadSpecificBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["arn:aws:s3:::meu-bucket/*"]
    }
  ]

  tags = {
    Ambiente = "dev"
  }
}
```

## Inputs principais

| Nome                             | Descricao                                              | Default          |
|-----------------------------------|---------------------------------------------------------|-------------------|
| region                             | Regiao AWS                                              | "us-east-1"       |
| role_name                          | Nome da IAM Role                                        | "app-role"        |
| policy_name                        | Nome da IAM Policy                                      | "app-policy"      |
| assume_role_service_principals     | Service principals autorizados a assumir a role         | ["ec2.amazonaws.com"] |
| assume_role_external_id            | External ID exigido na AssumeRole (opcional)             | null              |
| max_session_duration               | Duracao maxima da sessao assumida (segundos)             | 3600              |
| permissions_boundary_arn           | ARN de permissions boundary (opcional)                   | null              |
| policy_statements                  | Statements (sid, effect, actions, resources) da policy   | statement de exemplo (CloudWatch Logs) |
| tags                                | Tags aplicadas aos recursos                              | {}                |

## Outputs

| Nome                     | Descricao                                  |
|---------------------------|---------------------------------------------|
| role_arn                  | ARN da IAM Role criada                       |
| role_name                 | Nome da IAM Role criada                      |
| role_id                   | ID unico da IAM Role criada                  |
| policy_arn                | ARN da IAM Policy criada                     |
| policy_name                | Nome da IAM Policy criada                    |
| assume_role_policy_json   | JSON da trust policy da role                 |

## Validacao local

```
terraform init -backend=false
terraform validate
```

Nenhuma credencial AWS real e necessaria para `init`/`validate`, pois nao ha backend remoto nem data sources que dependam de chamadas autenticadas para essas etapas.
