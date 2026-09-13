# Blueprint Terraform — Bucket S3 (AWS)

Blueprint independente para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao, sem vinculo a padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls` — forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_versioning` — versionamento de objetos (habilitado por padrao).
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (AES256 por padrao, com opcao de SSE-KMS).
- `aws_s3_bucket_public_access_block` — bloqueio total de acesso publico (habilitado por padrao).

## Postura de seguranca padrao

- Acesso publico bloqueado (`block_public_access = true`).
- ACLs desabilitadas em favor de politicas de bucket (`BucketOwnerEnforced`).
- Criptografia em repouso habilitada por padrao (SSE-S3).
- Versionamento habilitado por padrao.
- Nenhum valor sensivel fixo no codigo; todos os parametros configuraveis sao expostos via variaveis.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123456"

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Variaveis principais

| Nome                    | Descricao                                                        | Padrao       |
|-------------------------|-------------------------------------------------------------------|--------------|
| `bucket_name`           | Nome globalmente unico do bucket                                   | (obrigatorio) |
| `aws_region`            | Regiao AWS de provisionamento                                      | `us-east-1`  |
| `force_destroy`         | Permite destruir o bucket com objetos dentro                       | `false`      |
| `versioning_enabled`    | Habilita versionamento de objetos                                   | `true`       |
| `enable_kms_encryption` | Usa SSE-KMS em vez de SSE-S3                                        | `false`      |
| `kms_key_arn`           | ARN da chave KMS (quando `enable_kms_encryption = true`)            | `""`         |
| `block_public_access`   | Bloqueia todo acesso publico ao bucket                              | `true`       |
| `tags`                  | Tags aplicadas ao bucket                                            | `{}`         |

## Outputs

| Nome                          | Descricao                                  |
|-------------------------------|---------------------------------------------|
| `bucket_id`                   | ID (nome) do bucket criado                   |
| `bucket_arn`                  | ARN do bucket                                |
| `bucket_domain_name`          | Nome de dominio do bucket                    |
| `bucket_regional_domain_name` | Nome de dominio regional do bucket           |
| `bucket_region`               | Regiao onde o bucket foi provisionado        |

## Validacao

Este blueprint foi projetado para ser validado sem credenciais reais nem backend remoto:

```
terraform init -backend=false
terraform validate
```
