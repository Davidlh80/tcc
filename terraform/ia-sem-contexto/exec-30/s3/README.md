# Modulo Terraform - Bucket S3 Seguro

Este modulo provisiona um bucket Amazon S3 com configuracoes seguras por padrao:

- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Controle de propriedade de objetos forcado para `BucketOwnerEnforced` (desabilita ACLs).
- Criptografia do lado do servidor habilitada por padrao (AES256, com suporte opcional a KMS).
- Versionamento configuravel por variavel.
- Aplicacao de tags customizaveis.

## Uso

```
module "s3_bucket" {
  source = "./"

  bucket_name        = "meu-bucket-exemplo-123"
  region             = "us-east-1"
  versioning_enabled = true
  sse_algorithm      = "AES256"

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

### Usando criptografia com KMS

```
module "s3_bucket" {
  source = "./"

  bucket_name   = "meu-bucket-exemplo-123"
  sse_algorithm = "aws:kms"
  kms_key_arn   = "arn:aws:kms:us-east-1:111111111111:key/exemplo-id"
}
```

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Entradas (Variables)

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|------|-----------|------|--------|-------------|
| region | Regiao AWS onde o bucket sera criado | string | "us-east-1" | nao |
| bucket_name | Nome globalmente unico do bucket S3 | string | - | sim |
| force_destroy | Permite exclusao do bucket mesmo com objetos | bool | false | nao |
| versioning_enabled | Habilita versionamento de objetos | bool | true | nao |
| sse_algorithm | Algoritmo de criptografia (AES256 ou aws:kms) | string | "AES256" | nao |
| kms_key_arn | ARN da chave KMS (usado quando sse_algorithm = aws:kms) | string | null | nao |
| tags | Tags adicionais aplicadas ao bucket | map(string) | {} | nao |

## Saidas (Outputs)

| Nome | Descricao |
|------|-----------|
| bucket_id | Identificador (nome) do bucket criado |
| bucket_arn | ARN do bucket criado |
| bucket_domain_name | Nome de dominio do bucket |
| bucket_regional_domain_name | Nome de dominio regional do bucket |
| versioning_status | Status de versionamento aplicado |
| sse_algorithm | Algoritmo de criptografia aplicado |

## Validacao

Este modulo foi projetado para ser validado sem credenciais reais ou backend remoto:

```
terraform init -backend=false
terraform validate
```

## Observacoes de seguranca

- O acesso publico ao bucket e bloqueado em todas as dimensoes (ACLs e politicas).
- ACLs sao desabilitadas via `BucketOwnerEnforced`, seguindo as recomendacoes atuais da AWS.
- A criptografia do lado do servidor e obrigatoria e habilitada por padrao.
- `force_destroy` e `false` por padrao para evitar exclusao acidental de dados.
