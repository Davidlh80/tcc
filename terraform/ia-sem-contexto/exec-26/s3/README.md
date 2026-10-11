# Modulo Terraform - Bucket S3

Provisiona um bucket Amazon S3 seguro por padrao, com bloqueio total de acesso publico, criptografia server-side, versionamento configuravel e suporte a tags customizadas.

## Recursos criados

- `aws_s3_bucket.this` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls.this` — forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block.this` — bloqueia qualquer forma de acesso publico (ACLs e policies).
- `aws_s3_bucket_server_side_encryption_configuration.this` — criptografia padrao SSE-S3 (AES256) ou SSE-KMS, se uma chave for informada.
- `aws_s3_bucket_versioning.this` — versionamento habilitado ou suspenso conforme variavel.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"

  versioning_enabled = true
  kms_key_arn        = null

  tags = {
    Ambiente = "dev"
    Time     = "plataforma"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS do bucket | string | "us-east-1" | nao |
| bucket_name | Nome unico do bucket S3 | string | - | sim |
| versioning_enabled | Habilita (true) ou suspende (false) o versionamento | bool | true | nao |
| kms_key_arn | ARN da chave KMS para SSE-KMS; nulo usa AES256 | string | null | nao |
| force_destroy | Permite destruir o bucket mesmo com objetos | bool | false | nao |
| tags | Tags adicionais para o bucket | map(string) | {} | nao |

## Outputs

| Nome | Descricao |
|---|---|
| bucket_id | Nome/ID do bucket criado |
| bucket_arn | ARN do bucket criado |
| bucket_domain_name | Dominio do bucket |
| bucket_regional_domain_name | Dominio regional do bucket |
| versioning_status | Status de versionamento aplicado |
| encryption_algorithm | Algoritmo de criptografia server-side aplicado |

## Seguranca

- Acesso publico bloqueado em todas as camadas (ACL e policy).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Validacao

```
terraform init -backend=false
terraform validate
```
