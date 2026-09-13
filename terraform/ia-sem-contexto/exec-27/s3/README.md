# S3 Bucket Blueprint

Blueprint Terraform para provisionamento de um bucket Amazon S3 seguro por padrao, gerado de forma autonoma sem vinculo a padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket.this` — bucket S3 principal, com tags padronizadas.
- `aws_s3_bucket_versioning.this` — versionamento de objetos (habilitado por padrao).
- `aws_s3_bucket_server_side_encryption_configuration.this` — criptografia server-side padrao (AES256 ou aws:kms).
- `aws_s3_bucket_ownership_controls.this` — forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block.this` — bloqueia todo acesso publico ao bucket.
- `data.aws_iam_policy_document.deny_insecure_transport` / `aws_s3_bucket_policy.deny_insecure_transport` — nega qualquer acesso via HTTP (nao criptografado).

## Postura de seguranca padrao

- Acesso publico totalmente bloqueado (ACLs e politicas publicas).
- ACLs desabilitadas via `BucketOwnerEnforced` (o proprietario do bucket sempre possui os objetos).
- Criptografia server-side obrigatoria (`AES256` por padrao, com suporte a `aws:kms`).
- Politica de bucket nega explicitamente conexoes sem TLS (`aws:SecureTransport = false`).
- Versionamento habilitado por padrao para protecao contra exclusao/sobrescrita acidental.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  environment = "dev"

  tags = {
    Owner = "time-plataforma"
  }
}
```

Para usar criptografia com KMS:

```
sse_algorithm = "aws:kms"
kms_key_arn   = "arn:aws:kms:us-east-1:123456789012:key/exemplo"
```

## Variaveis principais

| Nome              | Descricao                                              | Padrao      |
|-------------------|---------------------------------------------------------|-------------|
| bucket_name       | Nome globalmente unico do bucket                        | (obrigatorio) |
| aws_region        | Regiao AWS                                               | us-east-1   |
| environment       | Ambiente, usado em tags                                  | dev         |
| enable_versioning | Habilita versionamento                                   | true        |
| sse_algorithm     | Algoritmo de criptografia (AES256 ou aws:kms)            | AES256      |
| kms_key_arn       | ARN da chave KMS (quando sse_algorithm = aws:kms)        | null        |
| force_destroy     | Permite exclusao do bucket com objetos dentro            | false       |
| tags              | Tags adicionais                                          | {}          |

## Outputs

| Nome                        | Descricao                              |
|-----------------------------|------------------------------------------|
| bucket_id                   | Nome/identificador do bucket             |
| bucket_arn                  | ARN do bucket                            |
| bucket_domain_name          | Dominio do bucket                        |
| bucket_regional_domain_name | Dominio regional do bucket               |

## Validacao

Este modulo pode ser validado sem credenciais reais:

```
terraform init -backend=false
terraform validate
```
