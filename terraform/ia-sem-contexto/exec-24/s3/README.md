# Blueprint Terraform - Bucket S3

Blueprint Terraform para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao.

## Recursos criados

- `aws_s3_bucket.this` - bucket S3 principal.
- `aws_s3_bucket_versioning.this` - versionamento configuravel via variavel.
- `aws_s3_bucket_server_side_encryption_configuration.this` - criptografia server-side (SSE-S3 por padrao, ou SSE-KMS se uma chave for informada).
- `aws_s3_bucket_public_access_block.this` - bloqueio total de acesso publico.
- `aws_s3_bucket_ownership_controls.this` - forca a propriedade do objeto pelo dono do bucket (desabilita ACLs).

## Variaveis

| Nome | Tipo | Padrao | Descricao |
|---|---|---|---|
| `bucket_name` | string | - | Nome do bucket S3 (obrigatorio). |
| `versioning_enabled` | bool | `true` | Habilita ou suspende o versionamento. |
| `force_destroy` | bool | `false` | Permite destruir o bucket mesmo com objetos. |
| `kms_key_arn` | string | `null` | ARN de chave KMS para SSE-KMS; se omitido, usa AES256 (SSE-S3). |
| `tags` | map(string) | `{}` | Tags aplicadas ao bucket. |

## Outputs

| Nome | Descricao |
|---|---|
| `bucket_id` | Nome (id) do bucket. |
| `bucket_arn` | ARN do bucket. |
| `bucket_domain_name` | Dominio padrao do bucket. |
| `bucket_regional_domain_name` | Dominio regional do bucket. |
| `versioning_status` | Status atual do versionamento. |

## Uso

```
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123456"

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

Nenhum backend remoto e nenhuma credencial real sao necessarios para a validacao sintatica.
