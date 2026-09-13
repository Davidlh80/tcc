# Blueprint Terraform - Bucket Amazon S3

Blueprint para provisionamento de um bucket Amazon S3 seguro por padrao, gerado de forma autonoma sem vinculo com padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket`: bucket S3 principal.
- `aws_s3_bucket_ownership_controls`: forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_versioning`: controla o versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration`: criptografia server-side (AES256 por padrao, ou SSE-KMS se uma chave for informada).
- `aws_s3_bucket_public_access_block`: bloqueia todo acesso publico ao bucket.
- `aws_s3_bucket_lifecycle_configuration` (opcional): expira versoes nao atuais dos objetos.

## Decisoes de seguranca padrao

- Acesso publico totalmente bloqueado (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` = `true`).
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo a recomendacao atual da AWS.
- Criptografia server-side habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- Versionamento habilitado por padrao para proteger contra sobrescrita/exclusao acidental de objetos.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
}
```

Para usar SSE-KMS:

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
}
```

## Inputs

| Nome | Tipo | Padrao | Descricao |
|------|------|--------|-----------|
| aws_region | string | "us-east-1" | Regiao AWS onde o bucket sera provisionado |
| bucket_name | string | - | Nome globalmente unico do bucket S3 (obrigatorio) |
| force_destroy | bool | false | Permite destruir o bucket mesmo com objetos dentro |
| versioning_enabled | bool | true | Habilita versionamento de objetos |
| kms_key_arn | string | null | ARN de chave KMS para SSE-KMS; se nulo, usa AES256 |
| enable_lifecycle_rule | bool | false | Habilita expiracao de versoes nao atuais |
| noncurrent_version_expiration_days | number | 90 | Dias para expirar versoes nao atuais |
| tags | map(string) | {} | Tags adicionais aplicadas ao bucket |

## Outputs

| Nome | Descricao |
|------|-----------|
| bucket_id | Identificador (nome) do bucket criado |
| bucket_arn | ARN do bucket criado |
| bucket_regional_domain_name | Dominio regional do bucket |
| bucket_versioning_status | Status atual do versionamento |

## Validacao

Este blueprint pode ser validado sem credenciais reais:

```
terraform init -backend=false
terraform validate
```
