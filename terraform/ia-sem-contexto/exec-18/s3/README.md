# Blueprint Terraform — Amazon S3 Bucket

Blueprint para provisionamento de um bucket Amazon S3 seguro por padrão, com bloqueio de acesso público, criptografia server-side, versionamento e expiração de versões não atuais.

## Recursos criados

- `aws_s3_bucket` — bucket principal.
- `aws_s3_bucket_ownership_controls` — impõe `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia qualquer forma de acesso público.
- `aws_s3_bucket_versioning` — controla o versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia SSE-S3 (AES256) por padrão, ou SSE-KMS se uma chave for informada.
- `aws_s3_bucket_lifecycle_configuration` (opcional) — expira versões não atuais após N dias.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-unico-exemplo"

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Variáveis principais

| Nome                                   | Descrição                                              | Padrão        |
|-----------------------------------------|---------------------------------------------------------|---------------|
| `aws_region`                            | Região AWS                                               | `us-east-1`   |
| `bucket_name`                            | Nome único do bucket                                     | *obrigatório* |
| `force_destroy`                          | Permite exclusão do bucket com objetos                  | `false`       |
| `enable_versioning`                      | Habilita versionamento                                   | `true`        |
| `kms_key_arn`                            | ARN da chave KMS para SSE-KMS                            | `null`        |
| `enable_lifecycle_rule`                  | Habilita expiração de versões não atuais                 | `true`        |
| `noncurrent_version_expiration_days`     | Dias para expirar versões não atuais                     | `90`          |
| `tags`                                    | Tags aplicadas ao bucket                                 | `{}`          |

## Outputs

- `bucket_id`
- `bucket_arn`
- `bucket_domain_name`
- `bucket_regional_domain_name`
- `versioning_status`

## Segurança

- Acesso público totalmente bloqueado via `aws_s3_bucket_public_access_block`.
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia obrigatória em todos os objetos (SSE-S3 ou SSE-KMS).
- Nenhuma credencial ou valor sensível é fixado no código; todos os parâmetros configuráveis são expostos como variáveis.

## Validação

```
terraform init -backend=false
terraform validate
terraform fmt -check
```
