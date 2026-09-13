# Bucket S3 (Terraform)

Blueprint Terraform para provisionar um bucket Amazon S3 com configuracoes seguras por padrao: acesso publico bloqueado, propriedade de objetos controlada pelo bucket (ACLs desabilitadas), criptografia server-side habilitada e versionamento ativado.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_versioning` — controle de versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia padrao (SSE-S3 ou SSE-KMS).
- `aws_s3_bucket_ownership_controls` — forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia acesso publico via ACL e politica.

## Uso

```hcl
module "bucket" {
  source = "./"

  bucket_name = "meu-bucket-unico-exemplo"
  environment = "prod"
}
```

## Inputs

| Nome                  | Descricao                                                        | Tipo          | Default        |
|-----------------------|-------------------------------------------------------------------|---------------|----------------|
| aws_region            | Regiao AWS onde o bucket sera provisionado                       | string        | "us-east-1"    |
| bucket_name           | Nome globalmente unico do bucket S3                                | string        | (obrigatorio)  |
| environment           | Nome do ambiente usado para tagging                               | string        | "dev"          |
| enable_versioning     | Habilita versionamento de objetos                                 | bool          | true           |
| sse_algorithm         | Algoritmo de criptografia ("AES256" ou "aws:kms")                 | string        | "AES256"       |
| kms_key_arn           | ARN da chave KMS (necessario se sse_algorithm = "aws:kms")        | string        | null           |
| force_destroy         | Permite destruir o bucket mesmo com objetos dentro                | bool          | false          |
| block_public_access   | Bloqueia todo acesso publico ao bucket                            | bool          | true           |
| tags                  | Tags adicionais aplicadas ao bucket                               | map(string)   | {}             |

## Outputs

| Nome                         | Descricao                                  |
|------------------------------|---------------------------------------------|
| bucket_id                    | Identificador (nome) do bucket criado       |
| bucket_arn                   | ARN do bucket criado                        |
| bucket_domain_name           | Nome de dominio publico do bucket           |
| bucket_regional_domain_name  | Nome de dominio regional do bucket          |

## Seguranca

- Acesso publico bloqueado por padrao (`block_public_access = true`).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side obrigatoria em todos os objetos.
- Versionamento habilitado por padrao para protecao contra exclusao/sobrescrita acidental.

## Validacao

```bash
terraform init -backend=false
terraform validate
```
