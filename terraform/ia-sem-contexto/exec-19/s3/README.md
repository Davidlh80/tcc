# Blueprint Terraform: Bucket Amazon S3

Este modulo provisiona um bucket Amazon S3 com configuracoes seguras por padrao, adequado para uso geral de armazenamento de objetos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls` — forca propriedade do bucket sobre objetos (`BucketOwnerEnforced`), desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso publico ao bucket.
- `aws_s3_bucket_versioning` — habilita versionamento de objetos (configuravel).
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side padrao (SSE-S3 ou SSE-KMS).
- `aws_s3_bucket_lifecycle_configuration` — expira versoes nao atuais de objetos apos um numero configuravel de dias (opcional).

## Decisoes de seguranca padrao

- Acesso publico totalmente bloqueado (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` = `true`).
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo a recomendacao atual da AWS.
- Criptografia server-side habilitada por padrao (AES256), com suporte opcional a SSE-KMS via `kms_key_arn`.
- Versionamento habilitado por padrao para protecao contra exclusao/sobrescrita acidental.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Uso

```hcl
module "bucket" {
  source = "./"

  bucket_name       = "meu-bucket-exemplo-123"
  enable_versioning = true

  tags = {
    Environment = "producao"
    Owner       = "equipe-plataforma"
  }
}
```

## Variaveis

| Nome | Descricao | Tipo | Padrao |
|---|---|---|---|
| `bucket_name` | Nome globalmente unico do bucket S3 | `string` | — |
| `force_destroy` | Permite exclusao do bucket com objetos dentro | `bool` | `false` |
| `enable_versioning` | Habilita versionamento de objetos | `bool` | `true` |
| `kms_key_arn` | ARN de chave KMS para SSE-KMS | `string` | `null` |
| `enable_lifecycle_rule` | Habilita expiracao de versoes antigas | `bool` | `true` |
| `noncurrent_version_expiration_days` | Dias para expirar versoes nao atuais | `number` | `90` |
| `tags` | Tags adicionais do bucket | `map(string)` | `{}` |

## Outputs

| Nome | Descricao |
|---|---|
| `bucket_id` | Identificador (nome) do bucket |
| `bucket_arn` | ARN do bucket |
| `bucket_domain_name` | Dominio padrao do bucket |
| `bucket_regional_domain_name` | Dominio regional do bucket |
| `bucket_region` | Regiao onde o bucket foi criado |

## Validacao

```bash
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para validacao sintatica.
