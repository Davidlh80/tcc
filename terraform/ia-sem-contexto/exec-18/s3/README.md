# Blueprint Terraform — Bucket S3

Blueprint para provisionamento de um bucket Amazon S3 seguro por padrão.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso público (ACLs e políticas).
- `aws_s3_bucket_ownership_controls` — força `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side (AES256 por padrão, ou SSE-KMS se `kms_key_arn` for informado).
- `aws_s3_bucket_versioning` — versionamento configurável via variável.

## Variáveis

| Nome                 | Descrição                                                        | Tipo          | Padrão   |
|----------------------|-------------------------------------------------------------------|---------------|----------|
| `bucket_name`        | Nome globalmente único do bucket.                                  | `string`      | —        |
| `environment`        | Ambiente (ex: dev, staging, prod) usado em tags.                   | `string`      | `"dev"`  |
| `versioning_enabled` | Habilita/desabilita versionamento de objetos.                      | `bool`        | `true`   |
| `force_destroy`      | Permite destruir o bucket mesmo com objetos dentro.                | `bool`        | `false`  |
| `kms_key_arn`        | ARN de chave KMS para SSE-KMS; se nulo, usa AES256.                | `string`      | `null`   |
| `tags`               | Tags adicionais a mesclar com as tags padrão.                      | `map(string)` | `{}`     |

## Outputs

| Nome                          | Descrição                                      |
|-------------------------------|-------------------------------------------------|
| `bucket_id`                   | Nome/ID do bucket criado.                        |
| `bucket_arn`                  | ARN do bucket criado.                            |
| `bucket_regional_domain_name` | Domínio regional do bucket.                      |
| `versioning_status`           | Status atual do versionamento (`Enabled`/`Suspended`). |

## Uso

```hcl
module "bucket" {
  source      = "./"
  bucket_name = "minha-empresa-exemplo-bucket"
  environment = "prod"

  tags = {
    Owner = "equipe-plataforma"
  }
}
```

## Validação

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

## Segurança

- Acesso público bloqueado integralmente via `aws_s3_bucket_public_access_block`.
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia em repouso habilitada por padrão (AES256), com suporte opcional a SSE-KMS.
- Nenhuma credencial ou valor sensível fixo neste código.
