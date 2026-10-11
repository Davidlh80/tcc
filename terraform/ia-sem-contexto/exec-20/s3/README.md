# Modulo Terraform - Bucket S3

Blueprint Terraform para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao.

## Recursos criados

- `aws_s3_bucket.this`: bucket S3 principal.
- `aws_s3_bucket_public_access_block.this`: bloqueio total de acesso publico (ACLs e politicas publicas).
- `aws_s3_bucket_server_side_encryption_configuration.this`: criptografia do lado do servidor, usando SSE-S3 (AES256) por padrao ou SSE-KMS quando uma chave KMS for informada.
- `aws_s3_bucket_versioning.this`: versionamento de objetos, configuravel via variavel.
- `aws_s3_bucket_ownership_controls.this`: forca a propriedade dos objetos pelo proprietario do bucket (desabilita ACLs), seguindo as recomendacoes atuais da AWS.

## Uso

```hcl
module "bucket" {
  source = "./"

  bucket_name        = "minha-empresa-dados-123456"
  environment        = "prod"
  versioning_enabled = true

  tags = {
    Projeto = "exemplo"
    Time    = "plataforma"
  }
}
```

## Variaveis

| Nome                 | Descricao                                                              | Tipo          | Padrao  | Obrigatorio |
|----------------------|-------------------------------------------------------------------------|---------------|---------|-------------|
| `bucket_name`        | Nome globalmente unico do bucket S3.                                   | `string`      | -       | Sim         |
| `environment`         | Nome do ambiente, usado na tag `Environment`.                           | `string`      | `dev`   | Nao         |
| `versioning_enabled` | Habilita ou suspende o versionamento do bucket.                        | `bool`        | `true`  | Nao         |
| `kms_key_arn`        | ARN de chave KMS para SSE-KMS. Se `null`, usa SSE-S3 (AES256).         | `string`      | `null`  | Nao         |
| `tags`               | Tags adicionais mescladas com as tags padrao do modulo.                | `map(string)` | `{}`    | Nao         |

## Outputs

| Nome                           | Descricao                                                   |
|--------------------------------|---------------------------------------------------------------|
| `bucket_id`                    | Identificador (nome) do bucket criado.                        |
| `bucket_arn`                   | ARN do bucket criado.                                         |
| `bucket_regional_domain_name`  | Nome de dominio regional do bucket.                            |
| `versioning_status`            | Status atual do versionamento (`Enabled` ou `Suspended`).     |

## Seguranca

- Acesso publico bloqueado em todas as camadas (ACLs e politicas).
- Criptografia do lado do servidor habilitada por padrao (AES256), com suporte opcional a KMS.
- ACLs desabilitadas via `BucketOwnerEnforced`, seguindo a recomendacao atual da AWS para controle de acesso via IAM/bucket policy.
- Nenhuma credencial ou valor sensivel fixo no codigo; todos os valores configuraveis sao expostos via variaveis.

## Validacao

```
terraform init -backend=false
terraform validate
```
