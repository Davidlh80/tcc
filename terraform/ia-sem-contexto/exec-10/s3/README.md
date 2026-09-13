# Blueprint Terraform — Bucket Amazon S3

Este blueprint provisiona um bucket Amazon S3 com configuracoes seguras por padrao, adequado para uso geral de armazenamento de objetos.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls` — forca o modelo `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia todo acesso publico (ACLs e policies).
- `aws_s3_bucket_versioning` — habilita versionamento de objetos (configuravel).
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side padrao (SSE-S3/AES256, ou SSE-KMS se uma chave for informada).

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0
- Credenciais AWS configuradas via variaveis de ambiente, perfil ou outro metodo suportado pelo provider (nao incluidas neste blueprint).

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-2026"
  environment = "prod"

  tags = {
    Owner = "time-plataforma"
  }
}
```

## Variaveis principais

| Nome                | Descricao                                              | Padrao        |
|---------------------|---------------------------------------------------------|---------------|
| `aws_region`        | Regiao AWS                                               | `us-east-1`   |
| `bucket_name`       | Nome unico do bucket (obrigatorio)                       | -             |
| `environment`       | Ambiente (`dev`, `staging`, `prod`)                      | `dev`         |
| `enable_versioning` | Habilita versionamento                                   | `true`        |
| `force_destroy`     | Permite destruir bucket com objetos                      | `false`       |
| `kms_key_arn`       | ARN de chave KMS para SSE-KMS (opcional)                 | `null`        |
| `tags`              | Tags aplicadas ao bucket                                 | `{}`          |

## Outputs

- `bucket_id`: nome do bucket.
- `bucket_arn`: ARN do bucket.
- `bucket_domain_name`: dominio do bucket.
- `bucket_regional_domain_name`: dominio regional do bucket.
- `versioning_status`: status atual do versionamento.

## Seguranca

- Acesso publico bloqueado por padrao (ACLs e policies).
- Criptografia server-side habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo a recomendacao atual da AWS.
- `force_destroy` desabilitado por padrao para evitar perda acidental de dados.

## Validacao

```
terraform init -backend=false
terraform validate
```
