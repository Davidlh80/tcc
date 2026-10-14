# Bucket S3 — p26

Template Terraform que cria um bucket S3 privado, criptografado e com versionamento configurável.

> Template gerado com assistência de IA (Claude), com autorização do instrutor.

## Recursos criados

| Recurso | Finalidade |
|---|---|
| `aws_s3_bucket` | Bucket com tags obrigatórias |
| `aws_s3_bucket_public_access_block` | Bloqueia todo acesso público |
| `aws_s3_bucket_ownership_controls` | Desativa ACLs (`BucketOwnerEnforced`) |
| `aws_s3_bucket_server_side_encryption_configuration` | Criptografia SSE-KMS com bucket key |
| `aws_s3_bucket_versioning` | Versionamento controlado por variável |
| `aws_s3_bucket_policy` | Nega requisições sem TLS |

## Variáveis

| Nome | Tipo | Padrão | Descrição |
|---|---|---|---|
| `region` | `string` | `us-east-1` | Região AWS |
| `bucket_name` | `string` | — | Nome globalmente único do bucket |
| `environment` | `string` | — | `dev`, `hml` ou `prod` |
| `versioning_enabled` | `bool` | `true` | Habilita versionamento |
| `kms_key_arn` | `string` | `null` | Chave KMS própria; nulo usa `aws/s3` |
| `tags` | `map(string)` | `{}` | Tags adicionais |

## Outputs

`bucket_name`, `bucket_arn`, `bucket_id`.

## Uso

```bash
terraform init
terraform validate
terraform plan -var="bucket_name=meu-bucket-p26" -var="environment=dev"
```
