# Blueprint Terraform — Bucket S3

Blueprint para provisionar um bucket Amazon S3 seguro por padrão.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_versioning` — versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (SSE-S3 por padrão, ou SSE-KMS se `kms_key_arn` for informado).
- `aws_s3_bucket_ownership_controls` — força `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso público ao bucket.

## Uso

```hcl
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-unico"
  tags = {
    Owner = "time-plataforma"
  }
}
```

## Inputs

| Nome | Descrição | Tipo | Default | Obrigatório |
|---|---|---|---|---|
| region | Região AWS onde os recursos serão provisionados | string | "us-east-1" | não |
| bucket_name | Nome globalmente único do bucket S3 | string | — | sim |
| enable_versioning | Habilita versionamento de objetos | bool | true | não |
| force_destroy | Permite destruir o bucket mesmo com objetos dentro | bool | false | não |
| kms_key_arn | ARN de chave KMS para SSE-KMS; se nulo, usa AES256 | string | null | não |
| tags | Tags adicionais aplicadas ao bucket | map(string) | {} | não |

## Outputs

| Nome | Descrição |
|---|---|
| bucket_id | Identificador (nome) do bucket |
| bucket_arn | ARN do bucket |
| bucket_domain_name | Nome de domínio do bucket |
| bucket_regional_domain_name | Nome de domínio regional do bucket |

## Segurança

- Acesso público bloqueado em todas as dimensões (`aws_s3_bucket_public_access_block`).
- ACLs desabilitadas via `BucketOwnerEnforced`, exigindo controle de acesso apenas por políticas IAM/bucket policy.
- Criptografia server-side habilitada por padrão (AES256), com suporte opcional a SSE-KMS.
- Versionamento habilitado por padrão para proteção contra sobrescrita/exclusão acidental.
- `force_destroy` desabilitado por padrão para evitar perda acidental de dados.

## Validação

```
terraform init -backend=false
terraform validate
```
