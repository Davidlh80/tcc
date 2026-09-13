# S3 Bucket - Blueprint Terraform

Blueprint Terraform para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao.

## Recursos criados

- `aws_s3_bucket.this` - bucket S3 principal.
- `aws_s3_bucket_versioning.this` - versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration.this` - criptografia server-side (SSE-S3 por padrao ou SSE-KMS se `kms_key_arn` for informado).
- `aws_s3_bucket_ownership_controls.this` - propriedade dos objetos definida como `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block.this` - bloqueio total de acesso publico.

## Postura de seguranca padrao

- Acesso publico bloqueado em todas as dimensoes (ACLs e politicas).
- ACLs desabilitadas via `BucketOwnerEnforced` (o controle de acesso ocorre exclusivamente por politicas de bucket/IAM).
- Criptografia server-side habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- Versionamento habilitado por padrao para protecao contra exclusao/sobrescrita acidental.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Uso

```hcl
module "bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-unico"
  environment = "production"
}
```

## Variaveis

| Nome              | Tipo          | Padrao       | Descricao                                                  |
|-------------------|---------------|--------------|-------------------------------------------------------------|
| bucket_name       | string        | -            | Nome globalmente unico do bucket (obrigatorio).             |
| environment       | string        | "production" | Nome do ambiente, usado em tags.                             |
| force_destroy     | bool          | false        | Permite destruir o bucket mesmo com objetos.                 |
| enable_versioning | bool          | true         | Habilita versionamento de objetos.                           |
| kms_key_arn       | string        | null         | ARN de chave KMS para SSE-KMS; se null, usa SSE-S3 (AES256). |
| tags              | map(string)   | {}           | Tags adicionais aplicadas ao bucket.                         |

## Outputs

| Nome                          | Descricao                                  |
|-------------------------------|---------------------------------------------|
| bucket_id                     | Identificador (nome) do bucket criado.       |
| bucket_arn                    | ARN do bucket criado.                        |
| bucket_domain_name            | Nome de dominio do bucket.                   |
| bucket_regional_domain_name   | Nome de dominio regional do bucket.          |

## Validacao

```bash
terraform init -backend=false
terraform validate
```

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0
