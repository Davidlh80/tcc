# IAM Policy - Blueprint Terraform

Blueprint Terraform para provisionamento de uma IAM Policy na AWS, seguindo o principio de menor privilegio por padrao.

## Recursos criados

- `aws_iam_policy.this`: IAM Policy gerenciada, com documento gerado via `data.aws_iam_policy_document`.

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name        = "app-readonly-s3-policy"
  policy_description = "Permite leitura de objetos em bucket especifico"
  policy_actions      = ["s3:GetObject", "s3:ListBucket"]
  policy_resources    = [
    "arn:aws:s3:::my-app-bucket",
    "arn:aws:s3:::my-app-bucket/*"
  ]

  tags = {
    Environment = "production"
    Owner       = "team-platform"
  }
}
```

## Variaveis

| Nome                  | Descricao                                              | Tipo         | Default                                   |
|-----------------------|---------------------------------------------------------|--------------|--------------------------------------------|
| aws_region            | Regiao AWS                                               | string       | "us-east-1"                                |
| policy_name           | Nome da IAM Policy                                       | string       | "least-privilege-policy"                   |
| policy_path           | Path da IAM Policy                                       | string       | "/"                                        |
| policy_description    | Descricao da IAM Policy                                  | string       | "Policy gerada seguindo o principio de menor privilegio." |
| policy_actions        | Acoes IAM permitidas (sem wildcard `*`)                   | list(string) | ["s3:GetObject", "s3:ListBucket"]          |
| policy_resources      | ARNs de recursos alvo (evitar `*`)                        | list(string) | ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"] |
| tags                  | Tags aplicadas ao recurso                                 | map(string)  | { ManagedBy = "terraform" }                |

## Outputs

| Nome                  | Descricao                                  |
|-----------------------|---------------------------------------------|
| policy_arn            | ARN da IAM Policy criada                     |
| policy_id             | ID da IAM Policy criada                      |
| policy_name           | Nome da IAM Policy criada                    |
| policy_document_json  | Documento JSON gerado para a policy          |

## Consideracoes de seguranca

- Nao use `policy_actions` ou `policy_resources` com valor `*`; a variavel `policy_actions` bloqueia explicitamente o wildcard `*` via `validation`.
- A statement inclui uma condition `aws:SecureTransport = true`, exigindo HTTPS para as chamadas cobertas pela policy.
- Prefira escopar `policy_resources` ao ARN exato dos recursos necessarios, evitando permissoes amplas por conta ou regiao.
- Revise periodicamente as acoes concedidas para manter o principio de menor privilegio.

## Validacao

```
terraform init -backend=false
terraform validate
```
