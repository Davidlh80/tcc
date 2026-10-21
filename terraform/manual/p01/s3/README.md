# S3 - p01

Cria um bucket S3 privado com os quatro bloqueios de acesso publico, criptografia
server-side `AES256` e versionamento habilitado por padrao. O versionamento pode
ser suspenso pela variavel `versioning_enabled`, preservando as versoes existentes.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
| --- | --- | --- | --- |
| `bucket_name` | `string` | sim | Nome globalmente unico do bucket. |
| `environment` | `string` | sim | Ambiente do recurso: `dev` ou `prd`. |
| `versioning_enabled` | `bool` | nao | Habilita o versionamento do bucket. Padrao: `true`. |
| `additional_tags` | `map(string)` | nao | Tags adicionais aplicadas ao bucket. |

## Outputs

| Nome | Descricao |
| --- | --- |
| `bucket_name` | Nome do bucket criado. |
| `bucket_arn` | ARN do bucket criado. |
| `bucket_id` | ID do bucket criado. |

## Uso

```hcl
bucket_name        = "tcc-p01-dev-documents-123456789012"
environment        = "dev"
versioning_enabled = true
additional_tags    = { Project = "tcc" }
```

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
```
