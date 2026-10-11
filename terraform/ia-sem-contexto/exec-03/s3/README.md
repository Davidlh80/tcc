# Blueprint Terraform — Bucket S3 (AWS)

## Descricao

Este modulo provisiona um bucket Amazon S3 com configuracoes seguras por padrao:

- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Criptografia server-side habilitada por padrao (`AES256`), com suporte opcional a `aws:kms`.
- Versionamento configuravel via variavel (`versioning_enabled`), habilitado por padrao.
- Propriedade de objetos forcada para o proprietario do bucket (`BucketOwnerEnforced`), eliminando o uso de ACLs.
- Tags configuraveis, com valores padrao de ambiente e gerenciamento.

## Uso

```
module "s3_bucket" {
  source = "./"

  bucket_name        = "meu-bucket-exemplo-123"
  environment        = "prod"
  versioning_enabled = true
  sse_algorithm      = "AES256"

  tags = {
    Owner = "time-plataforma"
  }
}
```

Para usar criptografia com KMS:

```
module "s3_bucket" {
  source = "./"

  bucket_name   = "meu-bucket-exemplo-123"
  sse_algorithm = "aws:kms"
  kms_key_arn   = "arn:aws:kms:us-east-1:123456789012:key/exemplo"
}
```

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|---|---|---|---|---|
| bucket_name | Nome do bucket S3 | string | - | sim |
| environment | Nome do ambiente | string | "dev" | nao |
| versioning_enabled | Habilita versionamento | bool | true | nao |
| sse_algorithm | Algoritmo de criptografia (AES256 ou aws:kms) | string | "AES256" | nao |
| kms_key_arn | ARN da chave KMS (quando sse_algorithm = aws:kms) | string | null | nao |
| tags | Tags adicionais | map(string) | {} | nao |

## Outputs

| Nome | Descricao |
|---|---|
| bucket_id | Nome (ID) do bucket |
| bucket_arn | ARN do bucket |
| bucket_domain_name | Dominio padrao do bucket |
| bucket_regional_domain_name | Dominio regional do bucket |
| versioning_status | Status atual do versionamento |

## Validacao

```
terraform init -backend=false
terraform validate
```
