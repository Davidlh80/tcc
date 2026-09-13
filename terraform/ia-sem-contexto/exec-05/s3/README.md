# Blueprint Terraform - Bucket S3 (AWS)

Blueprint Terraform independente para provisionar um bucket Amazon S3 seguro por padrao, sem vinculo a padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket` - bucket S3 principal.
- `aws_s3_bucket_versioning` - controle de versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` - criptografia server-side (SSE-S3 por padrao, ou SSE-KMS se uma chave for informada).
- `aws_s3_bucket_ownership_controls` - forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` - bloqueia todo acesso publico ao bucket.
- `aws_s3_bucket_lifecycle_configuration` - expira versoes nao atuais apos N dias (opcional).

## Decisoes de seguranca padrao

- Acesso publico totalmente bloqueado (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` = `true`), sem opcao de flexibilizacao neste blueprint.
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo a recomendacao atual da AWS.
- Criptografia server-side habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- Versionamento habilitado por padrao para protecao contra sobrescrita/exclusao acidental.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Uso

```
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  region      = "us-east-1"

  tags = {
    Environment = "dev"
  }
}
```

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `bucket_name` | Nome globalmente unico do bucket | obrigatorio |
| `region` | Regiao AWS | `us-east-1` |
| `force_destroy` | Permite destruir bucket com objetos | `false` |
| `enable_versioning` | Habilita versionamento | `true` |
| `kms_key_arn` | ARN de chave KMS para SSE-KMS | `""` |
| `noncurrent_version_expiration_days` | Dias para expirar versoes antigas (0 desabilita) | `90` |
| `tags` | Tags aplicadas ao bucket | `{}` |

## Outputs

| Nome | Descricao |
|---|---|
| `bucket_id` | ID (nome) do bucket |
| `bucket_arn` | ARN do bucket |
| `bucket_domain_name` | Dominio do bucket |
| `bucket_regional_domain_name` | Dominio regional do bucket |
| `region` | Regiao do bucket |

## Validacao

Este blueprint foi projetado para ser validado sem credenciais reais e sem backend remoto:

```
terraform init -backend=false
terraform validate
```
