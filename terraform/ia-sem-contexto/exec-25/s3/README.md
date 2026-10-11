# Modulo Terraform: Bucket S3

Provisiona um bucket Amazon S3 com configuracoes seguras por padrao: bloqueio total de acesso publico, criptografia do lado do servidor, versionamento configuravel e tagueamento padronizado.

## Recursos criados

- `aws_s3_bucket.this` — bucket S3 principal.
- `aws_s3_bucket_public_access_block.this` — bloqueia qualquer forma de acesso publico ao bucket.
- `aws_s3_bucket_server_side_encryption_configuration.this` — habilita criptografia padrao (AES256 ou aws:kms).
- `aws_s3_bucket_versioning.this` — controla o versionamento de objetos.

## Uso

```
module "bucket" {
  source = "./"

  bucket_name        = "minha-empresa-dados-123456"
  environment        = "prod"
  versioning_enabled = true
  sse_algorithm      = "aws:kms"
  kms_key_arn        = "arn:aws:kms:us-east-1:123456789012:key/abc-123"

  tags = {
    Team = "plataforma"
  }
}
```

## Inputs

| Nome               | Descricao                                                             | Tipo          | Padrao   |
|--------------------|------------------------------------------------------------------------|---------------|----------|
| bucket_name        | Nome globalmente unico do bucket S3                                   | string        | -        |
| environment        | Ambiente usado para tagueamento                                       | string        | "dev"    |
| versioning_enabled | Habilita ou suspende o versionamento do bucket                        | bool          | true     |
| sse_algorithm      | Algoritmo de criptografia (AES256 ou aws:kms)                         | string        | "AES256" |
| kms_key_arn        | ARN da chave KMS, usado somente quando sse_algorithm = "aws:kms"      | string        | null     |
| force_destroy      | Permite destruir o bucket mesmo com objetos dentro                    | bool          | false    |
| tags               | Tags adicionais aplicadas ao bucket                                   | map(string)   | {}       |

## Outputs

| Nome                        | Descricao                                             |
|-----------------------------|--------------------------------------------------------|
| bucket_id                   | Nome (ID) do bucket criado                             |
| bucket_arn                  | ARN do bucket criado                                   |
| bucket_regional_domain_name | Dominio regional do bucket                              |
| versioning_status           | Status atual do versionamento ("Enabled"/"Suspended")  |
| sse_algorithm               | Algoritmo de criptografia aplicado                      |

## Observacoes de seguranca

- O acesso publico e bloqueado em todas as dimensoes (ACLs e politicas de bucket).
- A criptografia do lado do servidor e obrigatoria e habilitada por padrao com AES256.
- Para uso de `aws:kms`, forneca uma chave KMS gerenciada pelo cliente via `kms_key_arn`.
- `force_destroy` deve ser mantido em `false` em ambientes de producao para evitar perda acidental de dados.
