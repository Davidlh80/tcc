# IAM Policy — Blueprint Terraform

Blueprint autonomo para provisionamento de uma IAM Policy na AWS, gerado sem vinculo a padroes organizacionais especificos. As decisoes de nomenclatura, escopo de permissoes e tags seguem boas praticas gerais de mercado para Terraform e AWS, priorizando o principio de menor privilegio.

## Recursos criados

- `aws_iam_policy.this`: IAM Policy com statement unica, construida a partir de `data.aws_iam_policy_document.this`.

## Decisoes de seguranca

- Nao ha wildcard (`*`) permitido por padrao em `actions` nem em `resources`, tanto no valor padrao quanto via validacao das variaveis — forcando o consumidor da policy a declarar explicitamente as permissoes necessarias.
- `effect` e restrito a `Allow` ou `Deny` via validacao.
- Nenhuma credencial ou valor sensivel esta hardcoded no codigo.
- Nenhum backend remoto e configurado; o estado deve ser gerenciado externamente conforme a necessidade de cada ambiente.

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `aws_region` | Regiao AWS do provider | `us-east-1` |
| `policy_name` | Nome da IAM Policy | `example-restricted-policy` |
| `policy_description` | Descricao da IAM Policy | ver `variables.tf` |
| `path` | Path da IAM Policy | `/` |
| `effect` | Efeito da statement (`Allow`/`Deny`) | `Allow` |
| `actions` | Lista de actions IAM | `["s3:GetObject", "s3:ListBucket"]` |
| `resources` | Lista de ARNs de recursos | `["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]` |
| `tags` | Tags aplicadas ao recurso | `{}` |

## Outputs

- `policy_arn`: ARN da IAM Policy criada.
- `policy_id`: ID da IAM Policy criada.
- `policy_name`: Nome da IAM Policy criada.

## Uso

```
terraform init -backend=false
terraform validate
```

Para provisionar de fato, ajuste as variaveis `actions`, `resources`, `policy_name` e `tags` conforme o caso de uso real, mantendo o escopo minimo necessario, e forneca credenciais AWS validas antes de executar `terraform plan`/`terraform apply`.
