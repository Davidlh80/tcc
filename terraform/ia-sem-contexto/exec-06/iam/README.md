# IAM Policy — Blueprint Terraform

Blueprint Terraform para provisionamento de uma IAM Policy gerenciada na AWS, seguindo o principio de menor privilegio por padrao.

## Recursos criados

- `aws_iam_policy.this`: IAM Policy gerenciada, com documento gerado dinamicamente a partir da variavel `statements`.
- `data.aws_iam_policy_document.this`: documento JSON da politica, construido via `dynamic "statement"` a partir da lista de statements informada.

## Uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name        = "app-read-only-policy"
  policy_description = "Permite leitura de objetos em um bucket especifico."

  statements = [
    {
      sid       = "AllowAppS3Read"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = ["arn:aws:s3:::minha-app-bucket", "arn:aws:s3:::minha-app-bucket/*"]
    }
  ]

  tags = {
    Environment = "producao"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Nome                  | Descricao                                                        | Tipo           | Default                                  |
|-----------------------|-------------------------------------------------------------------|----------------|-------------------------------------------|
| aws_region            | Regiao AWS utilizada pelo provider                                | string         | `"us-east-1"`                             |
| policy_name           | Nome da IAM Policy                                                | string         | `"example-least-privilege-policy"`        |
| policy_description    | Descricao da IAM Policy                                          | string         | ver `variables.tf`                        |
| policy_path           | Path da IAM Policy                                               | string         | `"/"`                                     |
| statements            | Lista de statements (sid, effect, actions, resources) da politica| list(object)   | ver `variables.tf`                        |
| tags                  | Tags aplicadas ao recurso                                        | map(string)    | `{ ManagedBy = "terraform" }`              |

## Outputs

| Nome         | Descricao                          |
|--------------|--------------------------------------|
| policy_arn   | ARN da IAM Policy criada             |
| policy_id    | ID da IAM Policy criada              |
| policy_name  | Nome da IAM Policy criada            |

## Boas praticas de seguranca aplicadas

- Nenhuma action ou resource com wildcard (`*`) e definida por padrao; o exemplo padrao restringe acesso a um unico bucket S3.
- Cada statement exige `effect`, `actions` e `resources` explicitos e nao vazios, validados via `validation` blocks.
- Sem uso de backend remoto ou credenciais reais — compativel com `terraform init -backend=false` e `terraform validate`.
- Recomenda-se sempre revisar as `actions` e `resources` fornecidos antes de aplicar em ambientes produtivos, restringindo ao minimo necessario (least privilege).
