# IAM Policy — Blueprint Terraform

Blueprint autonomo para provisionar uma IAM Policy gerenciada pelo cliente na AWS, sem vinculo com padroes organizacionais especificos. As decisoes de privilegio, nomenclatura e escopo ficam a cargo de quem consome o modulo, atraves das variaveis de entrada.

## Recursos criados

- `aws_iam_policy.this`: IAM Policy gerenciada.
- `data.aws_iam_policy_document.this`: documento de politica com uma unica statement configuravel.

## Postura de seguranca

- Nenhum valor sensivel ou credencial e fixado no codigo.
- `actions` e `resources` sao obrigatorios e devem conter ao menos um item, incentivando o principio de menor privilegio.
- O uso do wildcard total `"*"` em `actions` ou `resources` e bloqueado por padrao via `precondition` no recurso. Para permitir explicitamente (assumindo o risco), defina `allow_wildcard_actions = true` e/ou `allow_wildcard_resources = true`.
- `effect` aceita apenas `Allow` ou `Deny`.
- Tags sao suportadas para rastreabilidade e governanca (`var.tags`).

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name         = "app-s3-read-only"
  policy_description  = "Permite leitura de objetos em um bucket especifico"
  effect              = "Allow"

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

| Nome                       | Tipo           | Padrao                    | Descricao                                                                 |
|----------------------------|----------------|----------------------------|----------------------------------------------------------------------------|
| `region`                   | `string`       | `"us-east-1"`              | Regiao AWS usada pelo provider.                                            |
| `policy_name`               | `string`       | -                           | Nome da IAM Policy.                                                        |
| `policy_description`        | `string`       | `"Gerenciada via Terraform."` | Descricao da IAM Policy.                                                |
| `path`                      | `string`       | `"/"`                       | Path da IAM Policy.                                                        |
| `effect`                    | `string`       | `"Allow"`                   | Efeito da statement (`Allow` ou `Deny`).                                   |
| `actions`                   | `list(string)` | -                           | Actions IAM da statement.                                                  |
| `resources`                 | `list(string)` | -                           | ARNs de recursos da statement.                                             |
| `allow_wildcard_actions`    | `bool`         | `false`                     | Permite explicitamente wildcard total em `actions`.                       |
| `allow_wildcard_resources`  | `bool`         | `false`                     | Permite explicitamente wildcard total em `resources`.                     |
| `conditions`                | `list(object)` | `[]`                        | Condicoes IAM opcionais (`test`, `variable`, `values`).                   |
| `tags`                      | `map(string)`  | `{}`                        | Tags aplicadas ao recurso.                                                 |

## Outputs

| Nome                    | Descricao                                  |
|-------------------------|---------------------------------------------|
| `policy_arn`            | ARN da IAM Policy criada.                   |
| `policy_id`             | ID da IAM Policy criada.                    |
| `policy_name`           | Nome da IAM Policy criada.                  |
| `policy_document_json`  | Documento JSON renderizado da policy.       |

## Validacao

```
terraform init -backend=false
terraform validate
```
