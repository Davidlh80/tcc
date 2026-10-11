# Modulo Terraform - Bucket S3

Blueprint Terraform para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao, incluindo bloqueio de acesso publico, criptografia server-side, versionamento configuravel e tagueamento.

## Recursos criados

- `aws_s3_bucket` - bucket S3 principal.
- `aws_s3_bucket_versioning` - controle de versionamento (habilitado ou suspenso via variavel).
- `aws_s3_bucket_server_side_encryption_configuration` - criptografia padrao (SSE-S3/AES256 ou SSE-KMS, conforme variavel `kms_key_arn`).
- `aws_s3_bucket_public_access_block` - bloqueio total de acesso publico (ACLs e politicas publicas).
- `aws_s3_bucket_ownership_controls` - forca propriedade do bucket owner, desabilitando ACLs legadas.

## Uso

```
module "bucket" {
  source = "./"

  bucket_name        = "minha-empresa-dados-prod"
  environment        = "prod"
  versioning_enabled = true
  kms_key_arn        = null

  tags = {
    Projeto = "exemplo"
  }
}
```

## Inputs

| Nome | Tipo | Padrao | Descricao |
|---|---|---|---|
| bucket_name | string | - | Nome globalmente unico do bucket (obrigatorio). |
| environment | string | "dev" | Nome do ambiente, usado em tags. |
| versioning_enabled | bool | true | Habilita ou suspende o versionamento. |
| kms_key_arn | string | null | ARN de chave KMS para SSE-KMS; se nulo, usa SSE-S3 (AES256). |
| force_destroy | bool | false | Permite destruir o bucket mesmo com objetos presentes. |
| tags | map(string) | {} | Tags adicionais mescladas com as tags padrao. |

## Outputs

| Nome | Descricao |
|---|---|
| bucket_id | Nome/identificador do bucket. |
| bucket_arn | ARN do bucket. |
| bucket_regional_domain_name | Nome de dominio regional do bucket. |
| versioning_status | Status atual do versionamento. |
| encryption_algorithm | Algoritmo de criptografia server-side aplicado. |

## Seguranca

- Acesso publico bloqueado por padrao em todas as dimensoes (ACLs e politicas).
- Criptografia server-side habilitada por padrao (AES256), com opcao de SSE-KMS.
- ACLs legadas desabilitadas via `BucketOwnerEnforced`.
- Nenhum valor sensivel ou credencial fixa no codigo.

## Validacao

Este modulo pode ser validado sem credenciais reais ou backend remoto:

```
terraform init -backend=false
terraform validate
```
