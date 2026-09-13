# Blueprint Terraform — Bucket Amazon S3

## Visao geral

Este blueprint provisiona um bucket S3 na AWS com configuracoes seguras por padrao, adequadas para a maioria dos casos de uso de armazenamento de objetos.

## Recursos criados

- `aws_s3_bucket` — bucket principal
- `aws_s3_bucket_versioning` — versionamento de objetos
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 ou SSE-KMS)
- `aws_s3_bucket_public_access_block` — bloqueio total de acesso publico
- `aws_s3_bucket_ownership_controls` — propriedade de objetos forcada pelo dono do bucket (desabilita ACLs)
- `aws_s3_bucket_lifecycle_configuration` — expiracao de versoes antigas e limpeza de multipart uploads incompletos (opcional)
- `aws_s3_bucket_logging` — logging de acesso para bucket de destino (opcional)
- `aws_s3_bucket_policy` — nega explicitamente trafego nao criptografado (HTTP)

## Decisoes de seguranca padrao

- Acesso publico bloqueado em todas as dimensoes (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`).
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo a recomendacao atual da AWS.
- Criptografia server-side habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- Versionamento habilitado por padrao para protecao contra exclusao/sobrescrita acidental.
- Politica de bucket nega qualquer acesso via conexao nao criptografada (`aws:SecureTransport = false`).
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-12345"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `bucket_name` | Nome globalmente unico do bucket | (obrigatorio) |
| `force_destroy` | Permite exclusao com objetos dentro | `false` |
| `enable_versioning` | Habilita versionamento | `true` |
| `kms_key_arn` | ARN de chave KMS para SSE-KMS | `null` (usa SSE-S3) |
| `enable_lifecycle_rule` | Habilita regra de ciclo de vida | `true` |
| `noncurrent_version_expiration_days` | Dias para expirar versoes antigas | `90` |
| `logging_target_bucket` | Bucket de destino para logs de acesso | `null` |
| `logging_target_prefix` | Prefixo dos logs de acesso | `s3-access-logs/` |
| `tags` | Tags aplicadas ao bucket | `{}` |

## Outputs

| Nome | Descricao |
|---|---|
| `bucket_id` | Nome do bucket criado |
| `bucket_arn` | ARN do bucket |
| `bucket_regional_domain_name` | Dominio regional do bucket |
| `account_id` | ID da conta AWS proprietaria |

## Observacoes

- A variavel `aws_region`, usada pelo provider em `versions.tf`, deve ser definida separadamente conforme a configuracao do ambiente de execucao (nao incluida neste blueprint por escopo).
- Nenhuma credencial real e necessaria para `terraform validate`.
- Nao ha uso de backend remoto neste blueprint.
