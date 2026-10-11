# Blueprint Terraform — Bucket S3

Blueprint para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao: acesso publico bloqueado, criptografia server-side habilitada, versionamento configuravel e aplicacao de tags.

## Recursos criados

- `aws_s3_bucket.this`: bucket S3 principal.
- `aws_s3_bucket_ownership_controls.this`: forca propriedade do objeto pelo dono do bucket (desabilita ACLs).
- `aws_s3_bucket_versioning.this`: controla o versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration.this`: define criptografia padrao (AES256 ou aws:kms).
- `aws_s3_bucket_public_access_block.this`: bloqueia todas as formas de acesso publico ao bucket.

## Variaveis principais

| Nome                | Descricao                                                    | Padrao   |
|---------------------|---------------------------------------------------------------|----------|
| `bucket_name`       | Nome globalmente unico do bucket                               | —        |
| `environment`        | Ambiente usado em tags                                        | `dev`    |
| `enable_versioning` | Habilita/desabilita versionamento                              | `true`   |
| `sse_algorithm`     | Algoritmo de criptografia (`AES256` ou `aws:kms`)              | `AES256` |
| `kms_key_id`        | Chave KMS usada quando `sse_algorithm = "aws:kms"`             | `null`   |
| `force_destroy`     | Permite destruir o bucket com objetos dentro                   | `false`  |
| `tags`              | Tags adicionais aplicadas ao bucket                             | `{}`     |

## Outputs

- `bucket_id`: nome do bucket.
- `bucket_arn`: ARN do bucket.
- `bucket_domain_name`: dominio padrao do bucket.
- `bucket_regional_domain_name`: dominio regional do bucket.
- `versioning_status`: status atual do versionamento.

## Uso

```hcl
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  environment = "prod"

  tags = {
    Owner = "time-plataforma"
  }
}
```

## Validacao

```bash
terraform init -backend=false
terraform validate
```

## Observacoes de seguranca

- Acesso publico e bloqueado por padrao via `aws_s3_bucket_public_access_block`.
- ACLs sao desabilitadas por padrao (`BucketOwnerEnforced`), seguindo a recomendacao atual da AWS.
- Criptografia server-side e obrigatoria para todos os objetos gravados no bucket.
- Para usar KMS, defina `sse_algorithm = "aws:kms"` e informe `kms_key_id` com o ARN da chave.
