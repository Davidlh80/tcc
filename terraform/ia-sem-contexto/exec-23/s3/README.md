# Modulo Terraform - Bucket S3

Blueprint Terraform para provisionar um bucket Amazon S3 com configuracoes seguras por padrao.

## Recursos criados

- `aws_s3_bucket` - bucket S3 principal.
- `aws_s3_bucket_ownership_controls` - forca o modelo `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` - bloqueia qualquer forma de acesso publico (ACLs e policies).
- `aws_s3_bucket_versioning` - versionamento configuravel via variavel.
- `aws_s3_bucket_server_side_encryption_configuration` - criptografia server-side (AES256 por padrao, com suporte opcional a KMS).

## Uso

```
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123456"
  aws_region  = "us-east-1"

  versioning_enabled = true
  sse_algorithm      = "AES256"

  tags = {
    Ambiente = "producao"
    Projeto  = "exemplo"
  }
}
```

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `bucket_name` | Nome globalmente unico do bucket | - (obrigatorio) |
| `aws_region` | Regiao AWS do provider | `us-east-1` |
| `versioning_enabled` | Habilita versionamento de objetos | `true` |
| `force_destroy` | Permite destruir bucket com objetos | `false` |
| `sse_algorithm` | Algoritmo de criptografia (`AES256` ou `aws:kms`) | `AES256` |
| `kms_master_key_id` | Chave KMS usada quando `sse_algorithm = "aws:kms"` | `null` |
| `tags` | Tags adicionais do bucket | `{}` |

## Outputs

- `bucket_id` - nome do bucket.
- `bucket_arn` - ARN do bucket.
- `bucket_domain_name` - dominio do bucket.
- `bucket_regional_domain_name` - dominio regional do bucket.
- `versioning_status` - status efetivo do versionamento.

## Seguranca

- Acesso publico bloqueado por padrao (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` todos `true`).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side habilitada por padrao com `AES256`; suporte opcional a `aws:kms` para controle de chave gerenciado pelo cliente.
- Nenhuma credencial ou valor sensivel fixo no codigo.

## Validacao

```
terraform init -backend=false
terraform validate
terraform fmt -check
```
