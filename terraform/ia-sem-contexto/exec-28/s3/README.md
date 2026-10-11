# Blueprint Terraform — Bucket Amazon S3

## Descricao

Esta blueprint provisiona um bucket Amazon S3 seguro por padrao, incluindo:

- Criacao do bucket com nome configuravel.
- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Criptografia server-side habilitada por padrao (`AES256`, com suporte opcional a `aws:kms`).
- Versionamento de objetos configuravel via variavel.
- Controle de propriedade de objetos forcando `BucketOwnerEnforced` (desabilita ACLs legadas).
- Aplicacao de tags customizaveis.
- Outputs com identificadores e metadados relevantes do bucket.

## Uso

```hcl
module "bucket" {
  source = "./"

  bucket_name        = "meu-bucket-exemplo-123456"
  versioning_enabled = true
  sse_algorithm      = "AES256"

  tags = {
    Ambiente = "producao"
    Projeto  = "exemplo"
  }
}
```

## Variaveis

| Nome                 | Tipo          | Padrao    | Descricao                                                                 |
|----------------------|---------------|-----------|----------------------------------------------------------------------------|
| `bucket_name`        | `string`      | —         | Nome globalmente unico do bucket (obrigatorio).                           |
| `versioning_enabled` | `bool`        | `true`    | Habilita ou suspende o versionamento do bucket.                           |
| `sse_algorithm`      | `string`      | `AES256`  | Algoritmo de criptografia padrao (`AES256` ou `aws:kms`).                 |
| `kms_key_arn`        | `string`      | `null`    | ARN da chave KMS, usado somente quando `sse_algorithm = "aws:kms"`.       |
| `force_destroy`      | `bool`        | `false`   | Permite destruir o bucket mesmo com objetos dentro. Usar com cautela.     |
| `tags`               | `map(string)` | `{}`      | Tags adicionais aplicadas ao bucket.                                      |

## Outputs

| Nome                          | Descricao                                           |
|-------------------------------|------------------------------------------------------|
| `bucket_id`                   | Identificador (nome) do bucket.                      |
| `bucket_arn`                  | ARN do bucket.                                       |
| `bucket_domain_name`          | Dominio padrao do bucket.                            |
| `bucket_regional_domain_name` | Dominio regional do bucket.                          |
| `bucket_region`               | Regiao AWS do bucket.                                |
| `versioning_status`           | Status atual do versionamento (`Enabled`/`Suspended`).|

## Seguranca

- Acesso publico e bloqueado em todas as camadas (ACLs e politicas).
- ACLs legadas sao desabilitadas via `BucketOwnerEnforced`.
- Criptografia server-side e obrigatoria para todos os objetos.
- `force_destroy` e `false` por padrao para evitar perda acidental de dados.

## Validacao

```bash
terraform init -backend=false
terraform validate
```
