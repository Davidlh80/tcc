# Modulo Terraform - Bucket S3

Provisiona um bucket Amazon S3 com configuracoes seguras por padrao: bloqueio total de acesso publico, criptografia server-side habilitada, versionamento configuravel e suporte a tags.

## Recursos criados

- `aws_s3_bucket.this` — bucket S3 principal.
- `aws_s3_bucket_versioning.this` — controla o versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration.this` — criptografia padrao (AES256 ou aws:kms).
- `aws_s3_bucket_public_access_block.this` — bloqueia ACLs e politicas publicas.
- `aws_s3_bucket_ownership_controls.this` — forca `BucketOwnerEnforced`, desabilitando ACLs.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"

  versioning_enabled = true
  sse_algorithm      = "AES256"

  tags = {
    Ambiente = "producao"
    Equipe   = "plataforma"
  }
}
```

## Variaveis

| Nome                 | Descricao                                                        | Tipo         | Default   |
|----------------------|-------------------------------------------------------------------|--------------|-----------|
| `bucket_name`        | Nome globalmente unico do bucket S3 (3 a 63 caracteres).          | `string`     | —         |
| `versioning_enabled` | Habilita o versionamento de objetos.                               | `bool`       | `true`    |
| `sse_algorithm`      | Algoritmo de criptografia padrao (`AES256` ou `aws:kms`).          | `string`     | `AES256`  |
| `kms_key_arn`        | ARN da chave KMS, usado somente quando `sse_algorithm = aws:kms`. | `string`     | `null`    |
| `tags`               | Mapa de tags aplicadas ao bucket.                                  | `map(string)`| `{}`      |

## Outputs

| Nome                          | Descricao                                        |
|-------------------------------|---------------------------------------------------|
| `bucket_id`                   | Identificador (nome) do bucket.                   |
| `bucket_arn`                  | ARN do bucket.                                    |
| `bucket_domain_name`          | Nome de dominio padrao do bucket.                 |
| `bucket_regional_domain_name` | Nome de dominio regional do bucket.               |
| `versioning_status`           | Status atual do versionamento (`Enabled`/`Suspended`). |

## Validacao

```
terraform init -backend=false
terraform validate
```

## Observacoes de seguranca

- Acesso publico e bloqueado por padrao via `aws_s3_bucket_public_access_block`.
- ACLs sao desabilitadas (`BucketOwnerEnforced`), forcando controle de acesso exclusivamente por politicas IAM/bucket policy.
- Criptografia server-side e sempre aplicada; para usar KMS, defina `sse_algorithm = "aws:kms"` e informe `kms_key_arn`.
