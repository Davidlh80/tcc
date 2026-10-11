# Blueprint Terraform - Bucket S3

Blueprint para provisionamento de um bucket Amazon S3 seguro por padrao, com bloqueio de acesso publico, criptografia obrigatoria, versionamento configuravel e tags.

## Recursos criados

- `aws_s3_bucket.this` - bucket S3 principal.
- `aws_s3_bucket_versioning.this` - controla o versionamento do bucket.
- `aws_s3_bucket_server_side_encryption_configuration.this` - criptografia do lado do servidor (AES256 por padrao, ou SSE-KMS se `kms_key_arn` for informado).
- `aws_s3_bucket_public_access_block.this` - bloqueia todo acesso publico ao bucket.
- `aws_s3_bucket_ownership_controls.this` - forca propriedade do bucket sobre os objetos, desabilitando ACLs.

## Uso

```
module "s3_bucket" {
  source       = "./"
  bucket_name  = "meu-bucket-exemplo-123"
  project_name = "meu-projeto"

  enable_versioning = true

  tags = {
    Owner = "equipe-plataforma"
  }
}
```

## Variaveis principais

| Nome                | Descricao                                             | Default        |
|----------------------|--------------------------------------------------------|----------------|
| `bucket_name`        | Nome globalmente unico do bucket                       | obrigatorio    |
| `project_name`       | Nome do projeto, usado na tag padrao `Project`          | `"sem-projeto"`|
| `enable_versioning`  | Habilita ou suspende o versionamento                   | `true`         |
| `kms_key_arn`        | ARN de chave KMS para SSE-KMS (opcional)               | `null`         |
| `force_destroy`      | Permite destruir o bucket com objetos dentro            | `false`        |
| `tags`               | Tags adicionais mescladas com as tags padrao            | `{}`           |

## Outputs

- `bucket_id` - nome (ID) do bucket.
- `bucket_arn` - ARN do bucket.
- `bucket_domain_name` - dominio do bucket.
- `bucket_regional_domain_name` - dominio regional do bucket.
- `versioning_status` - status atual do versionamento.

## Validacao

```
terraform init -backend=false
terraform validate
terraform fmt -check
```

## Seguranca

- Acesso publico bloqueado por padrao via `aws_s3_bucket_public_access_block`.
- Criptografia do lado do servidor obrigatoria (AES256 ou SSE-KMS).
- ACLs desabilitadas via `BucketOwnerEnforced`, forcando controle de acesso exclusivamente por politicas IAM/bucket policy.
- `force_destroy` desabilitado por padrao para evitar perda acidental de dados.
