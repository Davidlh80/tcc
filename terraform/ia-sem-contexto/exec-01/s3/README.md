# Blueprint Terraform — Bucket Amazon S3

Esta blueprint provisiona um bucket Amazon S3 seguro por padrao, incluindo:

- Criacao do bucket (`aws_s3_bucket`).
- Controle de propriedade de objetos com `BucketOwnerEnforced` (desabilita ACLs).
- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Criptografia do lado do servidor habilitada (SSE-S3/AES256 por padrao, ou SSE-KMS se uma chave for informada).
- Versionamento configuravel via variavel.
- Tags aplicadas ao recurso.
- Outputs relevantes para integracao com outros modulos.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-unico"

  versioning_enabled = true
  force_destroy      = false

  tags = {
    Projeto    = "exemplo"
    Ambiente   = "dev"
  }
}
```

## Variaveis principais

| Nome                 | Descricao                                                              | Default       |
|----------------------|-------------------------------------------------------------------------|---------------|
| `aws_region`         | Regiao AWS do provider                                                  | `us-east-1`   |
| `bucket_name`        | Nome globalmente unico do bucket (obrigatorio)                          | -             |
| `versioning_enabled` | Habilita ou suspende o versionamento do bucket                         | `true`        |
| `force_destroy`      | Permite exclusao do bucket mesmo com objetos (nao recomendado em prod) | `false`       |
| `kms_key_arn`        | ARN de chave KMS para SSE-KMS; vazio usa SSE-S3 (AES256)                | `""`          |
| `tags`               | Tags adicionais aplicadas ao bucket                                     | `{}`          |

## Outputs

| Nome                           | Descricao                                             |
|--------------------------------|--------------------------------------------------------|
| `bucket_id`                    | Nome (ID) do bucket criado                            |
| `bucket_arn`                   | ARN do bucket criado                                  |
| `bucket_domain_name`           | Dominio virtual-hosted-style do bucket                |
| `bucket_regional_domain_name`  | Dominio regional do bucket                             |
| `versioning_status`            | Status atual do versionamento                          |
| `encryption_algorithm`         | Algoritmo de criptografia aplicado (AES256 ou aws:kms) |

## Validacao

Este codigo foi estruturado para ser validado sem credenciais reais e sem backend remoto:

```
terraform init -backend=false
terraform validate
```

## Seguranca

- Acesso publico bloqueado em todas as dimensoes (ACLs e politicas).
- ACLs desabilitadas via `BucketOwnerEnforced`.
- Criptografia do lado do servidor sempre habilitada.
- Nenhum valor sensivel ou credencial fixa no codigo; todos os parametros configuraveis sao expostos via variaveis.
