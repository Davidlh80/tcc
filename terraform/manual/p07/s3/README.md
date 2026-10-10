# S3

Cria um bucket S3 privado, com bloqueio de acesso publico, criptografia SSE-S3 (AES256) e versionamento configuravel.

## Variaveis

| Nome | Tipo | Padrao | Descricao |
| --- | --- | --- | --- |
| `bucket_name` | string | - | Nome do bucket |
| `environment` | string | - | dev, hml ou prd |
| `enable_versioning` | bool | `true` | Habilita o versionamento |
| `additional_tags` | map(string) | `{}` | Tags extras |
| `region` | string | `us-east-1` | Regiao AWS |

## Outputs

`bucket_name`, `bucket_arn` e `bucket_id`.

## Uso

```sh
terraform init
terraform validate
terraform plan -var="bucket_name=meu-bucket-dev" -var="environment=dev"
```

As tags `Name`, `Environment` e `ManagedBy` sao sempre aplicadas e nao podem ser sobrescritas por `additional_tags`.
