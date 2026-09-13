# IAM Policy - Blueprint Terraform

Blueprint para provisionamento de uma IAM Policy na AWS, com permissoes definidas por statements configuraveis.

## Recursos criados

- `aws_iam_policy.this`

## Decisoes de design

- Nenhuma action ou resource usa wildcard (`*`) por padrao; o exemplo default concede apenas `s3:GetObject` e `s3:ListBucket` sobre um bucket especifico, seguindo o principio de menor privilegio.
- Os statements da policy sao totalmente configuraveis via a variavel `statements`, permitindo compor multiplas permissoes sem alterar o `main.tf`.
- Nao ha credenciais, ARNs de conta ou identificadores reais fixos no codigo; os valores sensiveis devem ser fornecidos via variaveis no momento do uso.
- Tags padrao incluem `ManagedBy = "terraform"` para rastreabilidade.

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name        = "minha-policy"
  policy_description = "Policy especifica para o time X"

  statements = [
    {
      sid       = "AllowReadSpecificBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::meu-bucket",
        "arn:aws:s3:::meu-bucket/*"
      ]
    }
  ]

  tags = {
    Environment = "prod"
    Owner       = "time-x"
  }
}
```

## Inputs

| Nome                 | Tipo                | Default                                   | Descricao                                        |
|----------------------|---------------------|--------------------------------------------|---------------------------------------------------|
| `aws_region`         | `string`            | `"us-east-1"`                              | Regiao usada pelo provider AWS                     |
| `policy_name`        | `string`            | `"least-privilege-example-policy"`         | Nome da IAM Policy                                 |
| `policy_description` | `string`            | Descricao generica                         | Descricao da IAM Policy                            |
| `policy_path`        | `string`            | `"/"`                                       | Path da IAM Policy                                 |
| `tags`                | `map(string)`      | `{ ManagedBy = "terraform" }`               | Tags aplicadas ao recurso                          |
| `statements`          | `list(object(...))`| Statement de exemplo com S3 read-only       | Statements que compoem o documento IAM da policy   |

## Outputs

| Nome          | Descricao                        |
|---------------|-----------------------------------|
| `policy_arn`  | ARN da IAM Policy criada          |
| `policy_id`   | ID da IAM Policy criada           |
| `policy_name` | Nome da IAM Policy criada         |

## Seguranca

- Revise cada statement antes de aplicar em producao; evite `actions = ["*"]` ou `resources = ["*"]`.
- Prefira escopar `resources` a ARNs especificos (bucket, role, tabela, etc.) em vez de abranger toda a conta.
- Anexe a policy somente as roles/usuarios/grupos que realmente precisam das permissoes concedidas (principio de menor privilegio).
- Valide o JSON gerado com `terraform plan` e, se possivel, com o IAM Access Analyzer antes do deploy.

## Validacao

```
terraform init -backend=false
terraform validate
```
