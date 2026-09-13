# Blueprint Terraform — Bucket Amazon S3

## Descrição

Este blueprint provisiona um bucket Amazon S3 com configurações seguras por padrão: acesso público totalmente bloqueado, propriedade de objeto forçada ao dono do bucket (`BucketOwnerEnforced`), criptografia no servidor (SSE-S3 ou SSE-KMS), versionamento habilitado e expiração automática de versões não atuais.

## Recursos criados

- `aws_s3_bucket`
- `aws_s3_bucket_ownership_controls`
- `aws_s3_bucket_public_access_block`
- `aws_s3_bucket_versioning`
- `aws_s3_bucket_server_side_encryption_configuration`
- `aws_s3_bucket_lifecycle_configuration` (opcional)
- `aws_s3_bucket_logging` (opcional)

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
}
```

## Variáveis principais

| Nome | Descrição | Padrão |
|---|---|---|
| `bucket_name` | Nome único do bucket | obrigatório |
| `aws_region` | Região AWS | `us-east-1` |
| `versioning_enabled` | Habilita versionamento | `true` |
| `kms_key_arn` | Chave KMS para SSE-KMS | `null` (usa AES256) |
| `force_destroy` | Permite destruir bucket não vazio | `false` |
| `enable_lifecycle_rule` | Expira versões não atuais | `true` |
| `noncurrent_version_expiration_days` | Dias para expiração de versões não atuais | `90` |
| `logging_target_bucket` | Bucket de destino para logs de acesso | `null` |
| `tags` | Tags adicionais | `{}` |

## Outputs

| Nome | Descrição |
|---|---|
| `bucket_id` | Nome do bucket |
| `bucket_arn` | ARN do bucket |
| `bucket_domain_name` | Domínio do bucket |
| `bucket_regional_domain_name` | Domínio regional do bucket |
| `bucket_region` | Região do bucket |

## Considerações de segurança

- Acesso público bloqueado em todas as dimensões (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`).
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo a recomendação atual da AWS.
- Criptografia no servidor habilitada por padrão (SSE-S3); pode ser trocada para SSE-KMS informando `kms_key_arn`.
- Versionamento habilitado por padrão para proteção contra sobrescrita e exclusão acidental.
- Nenhuma credencial ou valor sensível é fixado no código; todas as configurações variáveis são parametrizadas.

## Validação

```
terraform init -backend=false
terraform validate
```
