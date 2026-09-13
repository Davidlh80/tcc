# IAM Policy — Blueprint Terraform

Modulo Terraform para provisionar uma unica IAM Policy gerenciada pela AWS, com a statement (effect, actions, resources e condicoes) totalmente parametrizada.

## Recursos criados

- `data.aws_iam_policy_document.this`
- `aws_iam_policy.this`

## Uso

```hcl
module "iam_policy" {
  source = "./"

  name        = "app-s3-read-only"
  description = "Permite leitura de objetos em um bucket especifico"
  effect      = "Allow"

  actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  resources = [
    "arn:aws:s3:::meu-bucket-exemplo",
    "arn:aws:s3:::meu-bucket-exemplo/*",
  ]

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Inputs

| Nome         | Descricao                                              | Tipo           | Default                 | Obrigatorio |
|--------------|---------------------------------------------------------|----------------|--------------------------|-------------|
| name         | Nome da IAM Policy                                       | `string`       | -                         | sim         |
| description  | Descricao da IAM Policy                                  | `string`       | `"Managed by Terraform"` | nao         |
| path         | Path da IAM Policy no IAM                                 | `string`       | `"/"`                     | nao         |
| effect       | Efeito da statement (`Allow` ou `Deny`)                   | `string`       | `"Allow"`                | nao         |
| sid          | Sid opcional da statement                                 | `string`       | `null`                    | nao         |
| actions      | Lista de actions IAM cobertas pela policy                 | `list(string)` | -                         | sim         |
| resources    | Lista de ARNs de recursos aos quais a policy se aplica     | `list(string)` | -                         | sim         |
| conditions   | Lista opcional de condicoes IAM (test, variable, values)   | `list(object)` | `[]`                      | nao         |
| tags         | Tags aplicadas a IAM Policy                                | `map(string)`  | `{}`                      | nao         |

## Outputs

| Nome                   | Descricao                                    |
|------------------------|-----------------------------------------------|
| policy_arn             | ARN da IAM Policy criada                       |
| policy_id              | ID da IAM Policy criada                        |
| policy_name            | Nome da IAM Policy criada                      |
| policy_document_json   | Documento JSON da policy gerado                |

## Boas praticas de seguranca

- Nao ha defaults para `actions` e `resources`: o consumidor do modulo deve declarar explicitamente o que a policy permite, evitando o uso acidental de wildcards amplos (`"*"`).
- Prefira sempre ARNs especificos em `resources` e actions granulares em `actions`, seguindo o principio de menor privilegio.
- Use `conditions` para restringir ainda mais o escopo da policy (ex.: por IP de origem, MFA, tag de recurso, etc.).
- Revise o `policy_document_json` gerado antes de anexar esta policy a usuarios, grupos ou roles.
