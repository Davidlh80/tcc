# Blueprint Terraform — Bucket S3 (AWS)

Blueprint Terraform para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao.

## Recursos criados

- `aws_s3_bucket`: bucket S3 principal.
- `aws_s3_bucket_public_access_block`: bloqueio total de acesso publico (ACLs e policies).
- `aws_s3_bucket_server_side_encryption_configuration`: criptografia no lado do servidor (SSE-S3 por padrao, ou SSE-KMS se uma chave for informada).
- `aws_s3_bucket_versioning`: versionamento configuravel via variavel.
- `aws_s3_bucket_ownership_controls`: forca a propriedade dos objetos pelo bucket, desabilitando ACLs.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  tags = {
    Projeto = "exemplo"
    Time    = "plataforma"
  }
}
```

## Variaveis

| Nome                 | Tipo          | Padrao  | Descricao                                                                 |
|----------------------|---------------|---------|----------------------------------------------------------------------------|
| `bucket_name`        | `string`      | -       | Nome globalmente unico do bucket S3 (obrigatorio).                        |
| `versioning_enabled` | `bool`        | `true`  | Habilita (`Enabled`) ou suspende (`Suspended`) o versionamento.           |
| `kms_key_arn`        | `string`      | `null`  | ARN de chave KMS para SSE-KMS. Se nulo, usa SSE-S3 (AES256).              |
| `force_destroy`      | `bool`        | `false` | Permite destruir o bucket mesmo com objetos dentro. Usar com cautela.     |
| `tags`               | `map(string)` | `{}`    | Tags adicionais aplicadas ao bucket.                                       |

## Outputs

| Nome                          | Descricao                                             |
|-------------------------------|--------------------------------------------------------|
| `bucket_id`                   | Identificador (nome) do bucket criado.                 |
| `bucket_arn`                  | ARN do bucket criado.                                  |
| `bucket_domain_name`          | Nome de dominio padrao do bucket.                       |
| `bucket_regional_domain_name` | Nome de dominio regional do bucket.                     |
| `versioning_status`           | Status atual do versionamento (`Enabled`/`Suspended`). |

## Seguranca

- Acesso publico bloqueado por padrao (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`).
- Criptografia no lado do servidor habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo as recomendacoes atuais da AWS.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Validacao

```
terraform init -backend=false
terraform validate
```
