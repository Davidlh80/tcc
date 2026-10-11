# Modulo Terraform - Bucket Amazon S3

## Descricao

Este modulo provisiona um bucket Amazon S3 com configuracoes seguras por padrao:

- Bloqueio total de acesso publico (ACLs e politicas publicas).
- Criptografia do lado do servidor habilitada (SSE-S3 por padrao ou SSE-KMS se uma chave for informada).
- Versionamento configuravel via variavel.
- Aplicacao de tags customizaveis.

## Uso

```
module "s3_bucket" {
  source = "./"

  bucket_name        = "minha-empresa-dados-123456"
  versioning_enabled = true
  force_destroy      = false

  tags = {
    Environment = "production"
    Owner       = "team-data"
  }
}
```

## Requisitos

| Nome      | Versao   |
|-----------|----------|
| terraform | >= 1.5.0 |
| aws       | ~> 5.0   |

## Variaveis

| Nome                 | Descricao                                                             | Tipo          | Padrao  | Obrigatorio |
|----------------------|------------------------------------------------------------------------|---------------|---------|-------------|
| bucket_name          | Nome do bucket S3 (globalmente unico)                                  | string        | -       | sim         |
| versioning_enabled   | Habilita o versionamento do bucket                                     | bool          | true    | nao         |
| kms_key_arn          | ARN de chave KMS para SSE-KMS; se nulo, usa AES256                     | string        | null    | nao         |
| force_destroy        | Permite destruir o bucket mesmo com objetos dentro                     | bool          | false   | nao         |
| tags                 | Tags adicionais aplicadas ao bucket                                    | map(string)   | {}      | nao         |

## Outputs

| Nome                        | Descricao                                       |
|-----------------------------|--------------------------------------------------|
| bucket_id                   | Nome (ID) do bucket criado                       |
| bucket_arn                  | ARN do bucket criado                             |
| bucket_domain_name          | Dominio virtual-hosted-style do bucket           |
| bucket_regional_domain_name | Dominio regional do bucket                       |
| versioning_status           | Status atual do versionamento (Enabled/Suspended)|

## Seguranca

- O acesso publico ao bucket e bloqueado em todas as dimensoes (ACLs e politicas).
- A criptografia do lado do servidor e obrigatoria para todos os objetos gravados.
- Nenhuma credencial ou valor sensivel esta fixado no codigo; todos os parametros sensiveis devem ser fornecidos via variaveis.

## Validacao

Este modulo pode ser validado sintaticamente sem credenciais reais da AWS:

```
terraform init -backend=false
terraform validate
```
