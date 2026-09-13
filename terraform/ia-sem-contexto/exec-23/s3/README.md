# Blueprint Terraform — Bucket S3 (AWS)

Blueprint Terraform independente para provisionar um bucket Amazon S3 com configuracoes seguras por padrao, gerado sem vinculo a padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls` — forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso publico ao bucket.
- `aws_s3_bucket_versioning` — controla o versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 por padrao ou SSE-KMS se uma chave for informada).
- `aws_s3_bucket_policy` — nega explicitamente requisicoes que nao utilizem TLS (`aws:SecureTransport = false`).

## Decisoes de seguranca padrao

- Acesso publico totalmente bloqueado (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` = `true`).
- ACLs desabilitadas via `object_ownership = "BucketOwnerEnforced"`.
- Criptografia server-side obrigatoria em todos os objetos.
- Trafego HTTP (nao criptografado) negado por politica de bucket.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  aws_region  = "us-east-1"

  tags = {
    Environment = "producao"
    Owner       = "time-plataforma"
  }
}
```

## Inputs

| Nome              | Tipo          | Padrao        | Descricao                                                        |
|-------------------|---------------|---------------|-------------------------------------------------------------------|
| aws_region        | string        | "us-east-1"   | Regiao AWS onde o bucket sera criado.                              |
| bucket_name       | string        | (obrigatorio) | Nome globalmente unico do bucket, conforme regras da AWS.          |
| enable_versioning | bool          | true          | Habilita versionamento de objetos.                                 |
| force_destroy     | bool          | false         | Permite destruir o bucket mesmo com objetos dentro.                |
| kms_key_arn       | string        | null          | ARN de chave KMS para SSE-KMS; se omitido, usa SSE-S3 (AES256).    |
| tags              | map(string)   | {}            | Tags adicionais aplicadas ao bucket.                               |

## Outputs

| Nome                        | Descricao                                   |
|-----------------------------|-----------------------------------------------|
| bucket_id                   | Nome (ID) do bucket criado.                   |
| bucket_arn                  | ARN do bucket criado.                         |
| bucket_domain_name          | Nome de dominio do bucket.                    |
| bucket_regional_domain_name | Nome de dominio regional do bucket.           |
| bucket_region               | Regiao onde o bucket foi criado.              |

## Validacao

Este blueprint pode ser validado sem credenciais reais ou backend remoto:

```
terraform init -backend=false
terraform validate
```
