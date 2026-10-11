# Blueprint Terraform — Bucket Amazon S3

Blueprint para provisionamento de um bucket Amazon S3 com configurações seguras por padrão: bloqueio total de acesso público, criptografia do lado do servidor habilitada, versionamento configurável, ownership controls e tags.

## Recursos criados

- `aws_s3_bucket.this` — bucket S3.
- `aws_s3_bucket_public_access_block.this` — bloqueia qualquer forma de acesso público (ACLs e políticas).
- `aws_s3_bucket_versioning.this` — controla o versionamento de objetos.
- `aws_s3_bucket_server_side_encryption_configuration.this` — criptografia padrão (`AES256` ou `aws:kms`).
- `aws_s3_bucket_ownership_controls.this` — força `BucketOwnerEnforced`, desabilitando ACLs.

## Uso

```hcl
module "s3_bucket" {
  source = "./"

  bucket_name       = "minha-empresa-dados-123456"
  aws_region        = "us-east-1"
  enable_versioning = true
  sse_algorithm     = "AES256"

  tags = {
    Projeto    = "exemplo"
    Ambiente   = "producao"
  }
}
```

Para usar criptografia com KMS:

```hcl
module "s3_bucket" {
  source = "./"

  bucket_name   = "minha-empresa-dados-123456"
  sse_algorithm = "aws:kms"
  kms_key_id    = "arn:aws:kms:us-east-1:123456789012:key/chave-exemplo"
}
```

## Variáveis

| Nome | Descrição | Tipo | Padrão |
|---|---|---|---|
| `aws_region` | Região AWS do bucket | `string` | `"us-east-1"` |
| `bucket_name` | Nome globalmente único do bucket | `string` | — (obrigatório) |
| `enable_versioning` | Habilita versionamento | `bool` | `true` |
| `force_destroy` | Permite destruir bucket com objetos | `bool` | `false` |
| `sse_algorithm` | Algoritmo de criptografia (`AES256` ou `aws:kms`) | `string` | `"AES256"` |
| `kms_key_id` | ID/ARN da chave KMS (quando `aws:kms`) | `string` | `null` |
| `tags` | Tags adicionais | `map(string)` | `{}` |

## Outputs

| Nome | Descrição |
|---|---|
| `bucket_id` | Nome do bucket criado |
| `bucket_arn` | ARN do bucket |
| `bucket_domain_name` | Domínio do bucket |
| `bucket_regional_domain_name` | Domínio regional do bucket |
| `versioning_status` | Status do versionamento |
| `sse_algorithm` | Algoritmo de criptografia aplicado |

## Validação

```bash
terraform init -backend=false
terraform validate
terraform fmt -check
```

Nenhuma credencial real é necessária para `init` e `validate`, pois nenhum backend remoto ou data source dependente de credenciais é utilizado.
