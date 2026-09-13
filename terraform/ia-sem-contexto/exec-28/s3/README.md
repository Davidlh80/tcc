# Blueprint Terraform: Bucket S3 (AWS)

Blueprint standalone para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao, sem vinculo a padroes organizacionais especificos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls` — forca `BucketOwnerEnforced` (desabilita ACLs).
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso publico (ACLs e policies).
- `aws_s3_bucket_versioning` — versionamento configuravel (habilitado por padrao).
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia SSE-S3 (AES256) por padrao, ou SSE-KMS se uma chave for informada.
- `aws_s3_bucket_policy` — nega qualquer acesso via transporte nao criptografado (`aws:SecureTransport = false`).

## Postura de seguranca padrao

- Acesso publico totalmente bloqueado (ACLs e bucket policies).
- ACLs desabilitadas via ownership controls (`BucketOwnerEnforced`).
- Criptografia em repouso obrigatoria (SSE-S3 ou SSE-KMS).
- Conexoes HTTP (nao-TLS) bloqueadas por policy.
- `force_destroy` desabilitado por padrao para evitar remocao acidental de dados.

## Variaveis principais

| Nome                | Descricao                                              | Padrao |
|---------------------|---------------------------------------------------------|--------|
| `bucket_name`        | Nome global do bucket (obrigatorio)                     | —      |
| `environment`        | Nome do ambiente, usado em tags                         | `dev`  |
| `enable_versioning`  | Habilita versionamento                                  | `true` |
| `kms_key_arn`        | ARN de chave KMS para SSE-KMS (opcional)                | `null` |
| `force_destroy`      | Permite destruir bucket com objetos                     | `false`|
| `tags`               | Tags adicionais                                         | `{}`   |

## Outputs

- `bucket_id` — nome do bucket.
- `bucket_arn` — ARN do bucket.
- `bucket_regional_domain_name` — dominio regional do bucket.
- `bucket_versioning_status` — status de versionamento aplicado.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  environment = "prod"
}
```

## Validacao local

```
terraform init -backend=false
terraform validate
terraform fmt -check
```

Nenhuma credencial real e necessaria para `init` e `validate`.
