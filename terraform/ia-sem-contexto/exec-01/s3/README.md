# Blueprint Terraform — Bucket Amazon S3

Blueprint autônomo, sem vínculo com padrões organizacionais específicos, para provisionamento de um bucket S3 seguro por padrão na AWS.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_versioning` — versionamento de objetos (habilitado por padrão).
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 por padrão, ou SSE-KMS se `kms_key_arn` for informado).
- `aws_s3_bucket_ownership_controls` — força `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso público ao bucket.
- `aws_s3_bucket_policy` — nega explicitamente qualquer acesso via transporte não criptografado (HTTP).

## Decisões de segurança por padrão

- Acesso público totalmente bloqueado (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` = `true`).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side obrigatória em todos os objetos.
- Tráfego não criptografado (sem TLS) explicitamente negado via política de bucket.
- Versionamento habilitado por padrão para proteção contra sobrescrita/exclusão acidental.
- `force_destroy` desabilitado por padrão para evitar exclusão acidental de dados em produção.

## Uso

```
terraform init -backend=false
terraform validate
terraform plan -var="bucket_name=meu-bucket-unico"
```

## Variáveis principais

| Nome                 | Descrição                                          | Padrão        |
|----------------------|-----------------------------------------------------|---------------|
| `bucket_name`        | Nome globalmente único do bucket                    | —             |
| `aws_region`         | Região AWS                                          | `us-east-1`   |
| `environment`        | Ambiente (tag)                                      | `dev`         |
| `versioning_enabled` | Habilita versionamento                              | `true`        |
| `kms_key_arn`        | ARN de chave KMS para SSE-KMS (opcional)            | `null`        |
| `force_destroy`      | Permite destruir bucket com objetos                 | `false`       |
| `tags`               | Tags adicionais                                     | `{}`          |

## Outputs

- `bucket_id`
- `bucket_arn`
- `bucket_regional_domain_name`
- `versioning_status`
- `encryption_algorithm`

## Observações

- O nome do bucket (`bucket_name`) deve ser único globalmente na AWS e seguir as regras de nomenclatura de buckets S3.
- Este blueprint não define backend remoto; o estado é local por padrão.
- Nenhum valor sensível ou credencial é referenciado neste código.
