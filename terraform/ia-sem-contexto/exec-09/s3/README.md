# Modulo Terraform - Bucket S3 Seguro

Este modulo provisiona um bucket Amazon S3 com configuracoes seguras por padrao:

- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Criptografia server-side habilitada (SSE-S3/AES256 por padrao, ou SSE-KMS se uma chave for informada).
- Versionamento configuravel via variavel.
- Tags padronizadas, combinadas com tags adicionais fornecidas pelo usuario.
- Outputs relevantes para integracao com outros modulos.

## Uso

```
module "s3_bucket" {
  source = "./"

  bucket_name       = "minha-empresa-exemplo-bucket"
  aws_region        = "us-east-1"
  environment       = "prod"
  enable_versioning = true
  kms_key_arn       = null

  tags = {
    Owner = "time-plataforma"
  }
}
```

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0
- Credenciais AWS validas configuradas no ambiente de execucao (nao incluidas neste modulo).

## Inputs

| Nome               | Descricao                                                        | Tipo          | Padrao      | Obrigatorio |
|--------------------|-------------------------------------------------------------------|---------------|-------------|-------------|
| aws_region         | Regiao AWS onde o bucket sera criado                              | string        | us-east-1   | nao         |
| bucket_name        | Nome globalmente unico do bucket S3                               | string        | -           | sim         |
| environment        | Nome do ambiente, usado para tagging                               | string        | dev         | nao         |
| enable_versioning  | Habilita ou desabilita o versionamento do bucket                   | bool          | true        | nao         |
| kms_key_arn        | ARN de chave KMS para SSE-KMS; se null, usa SSE-S3 (AES256)        | string        | null        | nao         |
| force_destroy      | Permite destruir o bucket mesmo com objetos dentro                 | bool          | false       | nao         |
| tags               | Tags adicionais mescladas com as tags padrao do modulo             | map(string)   | {}          | nao         |

## Outputs

| Nome                         | Descricao                                                    |
|------------------------------|---------------------------------------------------------------|
| bucket_id                    | ID (nome) do bucket criado                                    |
| bucket_arn                   | ARN do bucket criado                                           |
| bucket_domain_name           | Nome de dominio do bucket                                      |
| bucket_regional_domain_name  | Nome de dominio regional do bucket                              |
| versioning_status            | Status atual do versionamento (Enabled/Suspended)               |
| encryption_algorithm         | Algoritmo de criptografia padrao aplicado (AES256 ou aws:kms)   |

## Validacao

Este modulo foi escrito para ser validado com:

```
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e nenhuma credencial real sao necessarios para a validacao sintatica.
