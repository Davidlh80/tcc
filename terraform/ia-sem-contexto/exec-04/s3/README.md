# Modulo Terraform - Bucket S3

Esta blueprint provisiona um bucket Amazon S3 com configuracoes seguras por padrao, incluindo bloqueio de acesso publico, criptografia no lado do servidor, versionamento configuravel e suporte a tags.

## Recursos criados

- `aws_s3_bucket.this`: o bucket S3.
- `aws_s3_bucket_public_access_block.this`: bloqueia qualquer forma de acesso publico ao bucket (ACLs e politicas publicas).
- `aws_s3_bucket_server_side_encryption_configuration.this`: habilita criptografia SSE-S3 (AES256) por padrao, ou SSE-KMS caso uma chave seja informada.
- `aws_s3_bucket_versioning.this`: habilita ou suspende o versionamento de objetos conforme variavel de entrada.
- `aws_s3_bucket_ownership_controls.this`: forca a propriedade dos objetos para o proprietario do bucket, desabilitando ACLs legadas.

## Uso

```
module "s3_bucket" {
  source = "./"

  aws_region        = "us-east-1"
  bucket_name       = "meu-bucket-exemplo-123456"
  enable_versioning = true

  tags = {
    Environment = "production"
    Owner       = "equipe-plataforma"
  }
}
```

## Variaveis

| Nome                | Descricao                                                        | Tipo          | Padrao      |
|---------------------|-------------------------------------------------------------------|---------------|-------------|
| `aws_region`        | Regiao AWS onde os recursos serao provisionados.                 | `string`      | `us-east-1` |
| `bucket_name`        | Nome do bucket S3 (deve ser globalmente unico).                  | `string`      | (obrigatorio) |
| `enable_versioning` | Habilita ou desabilita o versionamento do bucket.                | `bool`        | `true`      |
| `kms_key_arn`        | ARN de chave KMS para criptografia SSE-KMS (opcional).           | `string`      | `null`      |
| `tags`               | Tags adicionais a serem aplicadas ao bucket.                     | `map(string)` | `{}`        |

## Outputs

| Nome                           | Descricao                                             |
|--------------------------------|--------------------------------------------------------|
| `bucket_id`                    | ID (nome) do bucket S3 criado.                         |
| `bucket_arn`                   | ARN do bucket S3 criado.                               |
| `bucket_regional_domain_name`  | Nome de dominio regional do bucket.                    |
| `versioning_status`            | Status atual do versionamento do bucket.               |

## Seguranca

- Acesso publico e bloqueado em todas as camadas (ACLs e politicas de bucket).
- Criptografia no lado do servidor e habilitada por padrao (AES256), com suporte opcional a SSE-KMS.
- ACLs legadas sao desabilitadas via `BucketOwnerEnforced`, garantindo que o controle de acesso seja feito exclusivamente por politicas IAM/bucket policy.
- Nenhum valor sensivel ou credencial e fixado no codigo.

## Validacao

Este modulo pode ser validado sem credenciais reais ou backend remoto:

```
terraform init -backend=false
terraform validate
```
