# Blueprint Terraform — Bucket S3

Esta blueprint provisiona um bucket Amazon S3 seguro por padrao, incluindo:

- Criacao do bucket (`aws_s3_bucket`).
- Controle de ownership com `BucketOwnerEnforced`, desabilitando ACLs.
- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Criptografia server-side habilitada por padrao (AES256, com opcao de usar KMS).
- Versionamento configuravel via variavel.
- Tags padronizadas, mescladas com tags customizadas.
- Outputs relevantes (ID, ARN, dominios e status de versionamento).

## Uso

```
module "s3_bucket" {
  source = "./"

  bucket_name        = "meu-bucket-exemplo-12345"
  environment        = "prod"
  versioning_enabled = true
  sse_algorithm      = "AES256"

  tags = {
    Owner = "equipe-plataforma"
  }
}
```

## Variaveis principais

| Nome                 | Descricao                                                  | Padrao    |
|----------------------|-------------------------------------------------------------|-----------|
| `bucket_name`        | Nome globalmente unico do bucket                             | obrigatorio |
| `environment`        | Ambiente associado ao bucket                                 | `dev`     |
| `force_destroy`      | Permite exclusao do bucket com objetos dentro                | `false`   |
| `versioning_enabled` | Habilita versionamento de objetos                            | `true`    |
| `sse_algorithm`      | Algoritmo de criptografia (`AES256` ou `aws:kms`)             | `AES256`  |
| `kms_key_arn`        | ARN da chave KMS, usado quando `sse_algorithm = "aws:kms"`    | `null`    |
| `tags`               | Tags adicionais aplicadas ao bucket                           | `{}`      |

## Outputs

| Nome                          | Descricao                                 |
|-------------------------------|---------------------------------------------|
| `bucket_id`                   | Nome/ID do bucket                           |
| `bucket_arn`                  | ARN do bucket                               |
| `bucket_domain_name`          | Dominio do bucket                           |
| `bucket_regional_domain_name` | Dominio regional do bucket                  |
| `versioning_status`           | Status atual do versionamento               |
| `sse_algorithm`               | Algoritmo de criptografia configurado       |

## Seguranca

- Acesso publico bloqueado por padrao em todas as dimensoes (ACLs e policies).
- ACLs desabilitadas via `BucketOwnerEnforced`, forcando uso de policies IAM.
- Criptografia server-side habilitada por padrao, com suporte opcional a KMS.
- `force_destroy` desabilitado por padrao para evitar exclusao acidental de dados.

## Validacao

```
terraform init -backend=false
terraform validate
```
