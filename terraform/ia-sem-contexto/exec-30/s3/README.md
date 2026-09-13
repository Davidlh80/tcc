# Blueprint Terraform — Bucket Amazon S3

Blueprint autonomo para provisionamento de um bucket S3 seguro por padrao, sem vinculo com padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls` — forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso publico (ACLs e policies).
- `aws_s3_bucket_versioning` — versionamento de objetos (habilitado por padrao).
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 por padrao, ou SSE-KMS se `kms_key_arn` for informado).
- `aws_s3_bucket_lifecycle_configuration` — expira versoes antigas e aborta uploads multipart incompletos (opcional).
- `aws_s3_bucket_policy` — nega explicitamente requisicoes fora de HTTPS (`aws:SecureTransport = false`).

## Uso

```
terraform init -backend=false
terraform validate
terraform plan -var="bucket_name=meu-bucket-unico-global"
terraform apply -var="bucket_name=meu-bucket-unico-global"
```

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `region` | Regiao AWS | `us-east-1` |
| `bucket_name` | Nome globalmente unico do bucket | (obrigatorio) |
| `force_destroy` | Permite destruir bucket com objetos | `false` |
| `enable_versioning` | Habilita versionamento | `true` |
| `kms_key_arn` | ARN de chave KMS para SSE-KMS | `null` (usa SSE-S3) |
| `enable_lifecycle_rule` | Habilita regra de ciclo de vida | `true` |
| `noncurrent_version_expiration_days` | Dias para expirar versoes antigas | `90` |
| `tags` | Tags adicionais | `{}` |

## Outputs

- `bucket_id`
- `bucket_arn`
- `bucket_domain_name`
- `bucket_regional_domain_name`
- `account_id`

## Consideracoes de seguranca

- Acesso publico bloqueado em todas as dimensoes (`aws_s3_bucket_public_access_block`).
- ACLs desabilitadas via `BucketOwnerEnforced`, exigindo controle de acesso somente por policy.
- Criptografia em repouso habilitada por padrao (AES256), com suporte a KMS.
- Trafego nao criptografado (HTTP) e negado explicitamente via bucket policy.
- Versionamento habilitado por padrao para protecao contra exclusao/sobrescrita acidental.
