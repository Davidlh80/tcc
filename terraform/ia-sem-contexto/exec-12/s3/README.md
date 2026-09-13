# Blueprint Terraform — Amazon S3 Bucket

Blueprint autônomo, sem vínculo com padrões organizacionais específicos, para provisionamento de um bucket Amazon S3 seguro por padrão.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_ownership_controls` — força `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` — bloqueia acesso público (ACLs e políticas), habilitado por padrão.
- `aws_s3_bucket_versioning` — versionamento de objetos, habilitado por padrão.
- `aws_s3_bucket_server_side_encryption_configuration` — criptografia server-side padrão (AES256 ou aws:kms), com `bucket_key_enabled = true`.

## Decisões de segurança padrão

- Acesso público totalmente bloqueado (`block_public_access = true`).
- ACLs desabilitadas via `BucketOwnerEnforced` (o proprietário do bucket é sempre o dono dos objetos).
- Criptografia server-side habilitada por padrão com AES256; suporte a KMS via variável.
- Versionamento habilitado por padrão para proteção contra sobrescrita/exclusão acidental.
- `force_destroy = false` por padrão, evitando exclusão acidental de dados em produção.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-12345"
  environment = "prod"

  tags = {
    Owner = "time-plataforma"
  }
}
```

## Inputs

| Nome                  | Descrição                                                        | Tipo          | Default       |
|-----------------------|-------------------------------------------------------------------|---------------|---------------|
| aws_region            | Região AWS de provisionamento                                     | string        | "us-east-1"   |
| bucket_name           | Nome globalmente único do bucket                                  | string        | (obrigatório) |
| environment           | Nome do ambiente, usado em tags                                   | string        | "dev"         |
| tags                  | Tags adicionais                                                   | map(string)   | {}            |
| force_destroy         | Permite destruir bucket com objetos                               | bool          | false         |
| enable_versioning     | Habilita versionamento                                             | bool          | true          |
| block_public_access   | Bloqueia acesso público                                            | bool          | true          |
| sse_algorithm         | Algoritmo de criptografia padrão (AES256 ou aws:kms)              | string        | "AES256"      |
| kms_key_arn           | ARN da chave KMS (usado apenas se sse_algorithm = "aws:kms")      | string        | null          |

## Outputs

| Nome                          | Descrição                                  |
|-------------------------------|---------------------------------------------|
| bucket_id                     | Nome (ID) do bucket criado                  |
| bucket_arn                    | ARN do bucket criado                         |
| bucket_domain_name            | Domain name padrão do bucket                 |
| bucket_regional_domain_name   | Domain name regional do bucket               |

## Validação

```
terraform init -backend=false
terraform validate
```

Este blueprint não utiliza backend remoto e não depende de credenciais reais para validação sintática.
