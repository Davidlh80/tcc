# Blueprint Terraform — Bucket S3

Esta blueprint provisiona um bucket Amazon S3 com configuracoes seguras por padrao, incluindo bloqueio de acesso publico, criptografia server-side, versionamento configuravel e tagueamento.

## Recursos criados

- `aws_s3_bucket.this` — bucket S3 principal.
- `aws_s3_bucket_public_access_block.this` — bloqueia todo acesso publico (ACLs e politicas).
- `aws_s3_bucket_server_side_encryption_configuration.this` — habilita criptografia server-side (AES256 por padrao, ou SSE-KMS).
- `aws_s3_bucket_versioning.this` — controla o versionamento do bucket via variavel.

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `aws_region` | Regiao AWS | `us-east-1` |
| `bucket_name` | Nome unico do bucket | (obrigatorio) |
| `environment` | Ambiente para tagueamento | `dev` |
| `enable_versioning` | Habilita/suspende versionamento | `true` |
| `sse_algorithm` | `AES256` ou `aws:kms` | `AES256` |
| `kms_key_arn` | ARN da KMS key (quando `aws:kms`) | `null` |
| `force_destroy` | Permite destruir bucket com objetos | `false` |
| `tags` | Tags adicionais | `{}` |

## Outputs

- `bucket_id`
- `bucket_arn`
- `bucket_regional_domain_name`
- `versioning_status`
- `encryption_algorithm`

## Uso

```
terraform init -backend=false
terraform validate
terraform plan -var="bucket_name=meu-bucket-exemplo"
```

## Observacoes de seguranca

- O bloqueio de acesso publico esta sempre habilitado e nao e configuravel, por padrao de seguranca.
- Para usar criptografia com KMS, defina `sse_algorithm = "aws:kms"` e informe `kms_key_arn`.
- Nenhum backend remoto e configurado; para uso em produção, configure um backend remoto fora desta blueprint.
