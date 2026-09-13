# Blueprint Terraform — Amazon S3 Bucket

Provisiona um bucket Amazon S3 seguro por padrão, com bloqueio de acesso público, criptografia server-side, versionamento e ciclo de vida opcional.

## Recursos criados

- `aws_s3_bucket` — bucket S3.
- `aws_s3_bucket_ownership_controls` — força `BucketOwnerEnforced` (desabilita ACLs).
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso público.
- `aws_s3_bucket_versioning` — controla versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia SSE-S3 (AES256) por padrão, ou SSE-KMS se `kms_key_arn` for informado.
- `aws_s3_bucket_lifecycle_configuration` — regra opcional de expiração de objetos e versões antigas.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"

  tags = {
    Environment = "production"
    Owner       = "time-plataforma"
  }
}
```

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|-------------|
| aws_region | Região AWS onde o bucket será criado | `string` | `"us-east-1"` | não |
| bucket_name | Nome globalmente único do bucket S3 | `string` | n/a | sim |
| tags | Tags adicionais aplicadas ao bucket | `map(string)` | `{}` | não |
| versioning_enabled | Habilita versionamento de objetos | `bool` | `true` | não |
| kms_key_arn | ARN de chave KMS para SSE-KMS; se nulo, usa AES256 | `string` | `null` | não |
| force_destroy | Permite destruir o bucket mesmo com objetos | `bool` | `false` | não |
| enable_lifecycle_rule | Habilita regra de expiração de objetos/versões | `bool` | `false` | não |
| lifecycle_expiration_days | Dias para expiração quando lifecycle está habilitado | `number` | `365` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| bucket_id | Nome (ID) do bucket criado |
| bucket_arn | ARN do bucket criado |
| bucket_domain_name | Domínio do bucket |
| bucket_regional_domain_name | Domínio regional do bucket |
| versioning_status | Status atual do versionamento |

## Segurança

- Acesso público bloqueado em todas as camadas (ACLs, políticas).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side habilitada por padrão (AES256), com suporte a SSE-KMS.
- `force_destroy` desabilitado por padrão para evitar exclusão acidental de dados.

## Validação

```
terraform init -backend=false
terraform validate
```
