# Blueprint Terraform: Bucket Amazon S3

Blueprint autonoma para provisionamento de um bucket S3 seguro por padrao na AWS, sem vinculo com padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket`: bucket S3 principal.
- `aws_s3_bucket_ownership_controls`: forca o modelo `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_versioning`: controla o versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration`: criptografia server-side (AES256 por padrao, ou SSE-KMS se `kms_key_arn` for informado).
- `aws_s3_bucket_public_access_block`: bloqueia todo acesso publico ao bucket.
- `aws_s3_bucket_lifecycle_configuration` (opcional): expira versoes antigas de objetos apos N dias.

## Postura de seguranca padrao

- Acesso publico totalmente bloqueado (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` = `true`).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side habilitada por padrao (AES256).
- Versionamento habilitado por padrao.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS onde o bucket sera criado | string | "us-east-1" | nao |
| bucket_name | Nome globalmente unico do bucket S3 | string | - | sim |
| versioning_enabled | Habilita versionamento de objetos | bool | true | nao |
| kms_key_arn | ARN de chave KMS para SSE-KMS | string | null | nao |
| force_destroy | Permite destruir bucket com objetos | bool | false | nao |
| enable_lifecycle_rule | Habilita expiracao de versoes antigas | bool | true | nao |
| noncurrent_version_expiration_days | Dias para expirar versoes antigas | number | 90 | nao |
| tags | Tags aplicadas ao bucket | map(string) | {} | nao |

## Outputs

| Nome | Descricao |
|---|---|
| bucket_id | Nome (ID) do bucket criado |
| bucket_arn | ARN do bucket criado |
| bucket_domain_name | Dominio do bucket |
| bucket_regional_domain_name | Dominio regional do bucket |

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-12345"

  tags = {
    Environment = "dev"
  }
}
```

## Validacao

```
terraform init -backend=false
terraform validate
```

Nao ha dependencia de backend remoto ou credenciais reais para validacao sintatica.
