# Blueprint Terraform — Bucket S3 (AWS)

Blueprint para provisionar um bucket Amazon S3 seguro por padrão, sem vínculo com padrões organizacionais específicos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_versioning` — versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 ou SSE-KMS).
- `aws_s3_bucket_public_access_block` — bloqueio total de acesso público.
- `aws_s3_bucket_ownership_controls` — ownership enforced pelo dono do bucket (desabilita ACLs).
- `aws_s3_bucket_lifecycle_configuration` (opcional) — expiração de versões antigas e limpeza de uploads multipart incompletos.
- `aws_s3_bucket_policy` — nega explicitamente qualquer acesso via transporte não criptografado (HTTP).

## Decisões de segurança padrão

- Acesso público bloqueado em todas as dimensões (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia obrigatória em repouso (AES256 por padrão, ou SSE-KMS se `kms_key_arn` for informado).
- Política de bucket nega qualquer requisição que não use TLS (`aws:SecureTransport = false`).
- Versionamento habilitado por padrão para proteção contra sobrescrita/exclusão acidental.
- `force_destroy` desabilitado por padrão para evitar exclusão acidental de dados.

## Uso

```hcl
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-12345"
  aws_region  = "us-east-1"

  tags = {
    ambiente = "producao"
  }
}
```

## Variáveis principais

| Nome                                  | Descrição                                              | Padrão        |
|----------------------------------------|---------------------------------------------------------|---------------|
| `bucket_name`                          | Nome globalmente único do bucket (obrigatório)          | -             |
| `aws_region`                           | Região AWS de provisionamento                            | `us-east-1`   |
| `force_destroy`                        | Permite exclusão do bucket com objetos dentro           | `false`       |
| `enable_versioning`                    | Habilita versionamento                                   | `true`        |
| `kms_key_arn`                          | ARN de chave KMS para SSE-KMS (vazio = SSE-S3)          | `""`          |
| `enable_lifecycle_rule`                | Habilita regra de ciclo de vida                          | `true`        |
| `noncurrent_version_expiration_days`   | Dias até expirar versões não-atuais                      | `90`          |
| `tags`                                 | Tags adicionais para o bucket                            | `{}`          |

## Outputs

| Nome                          | Descrição                                  |
|-------------------------------|---------------------------------------------|
| `bucket_id`                   | Nome do bucket criado                       |
| `bucket_arn`                  | ARN do bucket criado                        |
| `bucket_regional_domain_name` | Domínio regional do bucket                  |
| `bucket_versioning_status`    | Status atual do versionamento               |

## Validação

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

## Observações

- Nenhuma credencial real é necessária para `init`/`validate`.
- Nenhum backend remoto é configurado; para uso em produção, configure um backend adequado externamente ao módulo.
- Ajuste `noncurrent_version_expiration_days` e `enable_lifecycle_rule` conforme a política de retenção de dados aplicável ao caso de uso.
