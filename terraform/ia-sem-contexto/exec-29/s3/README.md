# Modulo Terraform — Bucket S3 (AWS)

Provisiona um bucket Amazon S3 com configuracoes seguras por padrao: acesso publico bloqueado, propriedade de objetos controlada pelo dono do bucket, versionamento habilitado e criptografia server-side ativa.

## Recursos criados

- `aws_s3_bucket`
- `aws_s3_bucket_ownership_controls`
- `aws_s3_bucket_versioning`
- `aws_s3_bucket_server_side_encryption_configuration`
- `aws_s3_bucket_public_access_block`

## Uso

```hcl
module "bucket" {
  source = "./"

  bucket_name = "meu-bucket-exemplo-2026"

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS onde os recursos serao provisionados | string | "us-east-1" | nao |
| bucket_name | Nome do bucket S3 (globalmente unico) | string | - | sim |
| tags | Tags aplicadas ao bucket | map(string) | {} | nao |
| force_destroy | Permite exclusao do bucket com objetos existentes | bool | false | nao |
| versioning_enabled | Habilita versionamento de objetos | bool | true | nao |
| sse_algorithm | Algoritmo de criptografia (`AES256` ou `aws:kms`) | string | "AES256" | nao |
| kms_master_key_id | ARN/ID da chave KMS quando `sse_algorithm = "aws:kms"` | string | null | nao |
| block_public_access | Bloqueia todo acesso publico ao bucket | bool | true | nao |

## Outputs

| Nome | Descricao |
|---|---|
| bucket_id | Nome (ID) do bucket criado |
| bucket_arn | ARN do bucket criado |
| bucket_domain_name | Dominio do bucket |
| bucket_regional_domain_name | Dominio regional do bucket |
| bucket_region | Regiao onde o bucket foi criado |

## Seguranca

- Acesso publico bloqueado por padrao (`block_public_access = true`).
- Propriedade de objetos forcada para o dono do bucket (`BucketOwnerEnforced`), eliminando o uso de ACLs.
- Criptografia server-side habilitada por padrao com `AES256`; pode ser alterada para `aws:kms` informando `kms_master_key_id`.
- Versionamento habilitado por padrao para proteger contra sobrescrita/exclusao acidental de objetos.
- `force_destroy` desabilitado por padrao para evitar perda acidental de dados.

## Validacao

```bash
terraform init -backend=false
terraform validate
```
