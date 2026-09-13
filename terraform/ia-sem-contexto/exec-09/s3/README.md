# Blueprint Terraform — Bucket S3 (AWS)

Este blueprint provisiona um bucket Amazon S3 seguro por padrao, sem vinculo com padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls` — forca propriedade do objeto pelo dono do bucket (`BucketOwnerEnforced`), desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso publico (ACLs e politicas).
- `aws_s3_bucket_versioning` — versionamento configuravel (habilitado por padrao).
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 por padrao, ou SSE-KMS se `kms_key_arn` for informado).
- `aws_s3_bucket_lifecycle_configuration` (opcional) — expira versoes nao-atuais apos um numero configuravel de dias.

## Decisoes de seguranca padrao

- Acesso publico totalmente bloqueado (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` = `true`).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side habilitada por padrao (AES256), com opcao de usar KMS.
- Versionamento habilitado por padrao para permitir recuperacao de objetos.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Variaveis principais

| Nome                                  | Descricao                                                        | Padrao   |
|----------------------------------------|-------------------------------------------------------------------|----------|
| `bucket_name`                          | Nome globalmente unico do bucket                                  | -        |
| `force_destroy`                        | Permite destruir bucket com objetos                               | `false`  |
| `versioning_enabled`                   | Habilita versionamento                                             | `true`   |
| `kms_key_arn`                          | ARN de chave KMS para SSE-KMS (opcional)                           | `null`   |
| `enable_lifecycle_rule`                | Habilita expiracao de versoes nao-atuais                           | `true`   |
| `noncurrent_version_expiration_days`   | Dias para expirar versoes nao-atuais                               | `90`     |
| `tags`                                 | Mapa de tags aplicadas ao bucket                                   | `{}`     |

## Outputs

- `bucket_id` — nome/ID do bucket.
- `bucket_arn` — ARN do bucket.
- `bucket_domain_name` — dominio do bucket.
- `bucket_regional_domain_name` — dominio regional do bucket.
- `bucket_region` — regiao onde o bucket foi criado.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-12345"

  tags = {
    Ambiente = "producao"
  }
}
```

## Validacao

```
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para validacao sintatica.
