# Modulo Terraform - Bucket S3

Blueprint Terraform para provisionamento de um bucket Amazon S3 seguro por padrao, com bloqueio de acesso publico, criptografia server-side, versionamento configuravel e tagueamento.

## Recursos criados

- `aws_s3_bucket` - bucket S3 principal.
- `aws_s3_bucket_ownership_controls` - forca `BucketOwnerEnforced`, desabilitando ACLs.
- `aws_s3_bucket_public_access_block` - bloqueia qualquer forma de acesso publico ao bucket.
- `aws_s3_bucket_versioning` - habilita ou suspende versionamento conforme variavel.
- `aws_s3_bucket_server_side_encryption_configuration` - aplica criptografia SSE-S3 (AES256) por padrao, ou SSE-KMS caso uma chave seja informada.

## Uso

```hcl
module "bucket" {
  source      = "./"
  bucket_name = "minha-empresa-dados-123456"
  environment = "prod"

  versioning_enabled = true
  kms_key_arn        = null

  tags = {
    Owner = "time-plataforma"
  }
}
```

## Variaveis

| Nome                | Descricao                                                                 | Tipo          | Padrao  |
|----------------------|----------------------------------------------------------------------------|---------------|---------|
| `bucket_name`        | Nome globalmente unico do bucket S3.                                      | `string`      | -       |
| `environment`        | Nome do ambiente, usado em tags.                                          | `string`      | `"dev"` |
| `versioning_enabled` | Habilita (`Enabled`) ou suspende (`Suspended`) o versionamento.           | `bool`        | `true`  |
| `kms_key_arn`        | ARN de chave KMS para SSE-KMS. Se nulo, usa SSE-S3 (AES256).              | `string`      | `null`  |
| `force_destroy`      | Permite destruir o bucket mesmo com objetos dentro. Use com cautela.      | `bool`        | `false` |
| `tags`               | Tags adicionais aplicadas ao bucket.                                      | `map(string)` | `{}`    |

## Outputs

| Nome                          | Descricao                                                   |
|--------------------------------|---------------------------------------------------------------|
| `bucket_id`                    | Identificador (nome) do bucket criado.                       |
| `bucket_arn`                   | ARN do bucket criado.                                         |
| `bucket_domain_name`           | Nome de dominio do bucket.                                    |
| `bucket_regional_domain_name`  | Nome de dominio regional do bucket.                            |
| `bucket_region`                | Regiao AWS do bucket.                                          |
| `versioning_status`            | Status atual do versionamento (`Enabled` ou `Suspended`).     |
| `encryption_algorithm`         | Algoritmo de criptografia aplicado (`AES256` ou `aws:kms`).    |

## Seguranca

- Acesso publico sempre bloqueado via `aws_s3_bucket_public_access_block`.
- ACLs desabilitadas via `BucketOwnerEnforced`, forcando controle de acesso exclusivamente por politicas IAM/bucket policy.
- Criptografia server-side habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- Nenhuma credencial ou valor sensivel esta fixado no codigo; todos os parametros configuraveis sao expostos via variaveis.

## Validacao

```bash
terraform init -backend=false
terraform validate
```
