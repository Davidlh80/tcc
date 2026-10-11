# Blueprint Terraform - Bucket S3

Blueprint Terraform para provisionamento de um bucket Amazon S3 seguro por padrao, cobrindo:

- Criacao do bucket com nome configuravel.
- Bloqueio total de acesso publico (`aws_s3_bucket_public_access_block`).
- Ownership controls com `BucketOwnerEnforced` (desabilita ACLs).
- Criptografia do lado do servidor habilitada por padrao (AES256, com suporte opcional a SSE-KMS).
- Versionamento configuravel via variavel.
- Tagueamento padronizado, mesclado com tags adicionais fornecidas pelo usuario.

## Uso

```
module "s3_bucket" {
  source      = "./"
  bucket_name = "meu-bucket-exemplo-123"
  environment = "prod"
}
```

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Variaveis principais

| Nome | Descricao | Tipo | Default |
|------|-----------|------|---------|
| `aws_region` | Regiao AWS | `string` | `"us-east-1"` |
| `bucket_name` | Nome unico do bucket | `string` | - (obrigatorio) |
| `environment` | Ambiente para tagueamento | `string` | `"dev"` |
| `versioning_enabled` | Habilita versionamento | `bool` | `true` |
| `force_destroy` | Permite destruir bucket nao vazio | `bool` | `false` |
| `sse_algorithm` | Algoritmo de criptografia (`AES256` ou `aws:kms`) | `string` | `"AES256"` |
| `kms_master_key_arn` | ARN da chave KMS (quando `aws:kms`) | `string` | `null` |
| `tags` | Tags adicionais | `map(string)` | `{}` |

## Outputs

| Nome | Descricao |
|------|-----------|
| `bucket_id` | Nome do bucket criado |
| `bucket_arn` | ARN do bucket |
| `bucket_domain_name` | Dominio virtual-hosted-style do bucket |
| `bucket_regional_domain_name` | Dominio regional do bucket |
| `versioning_status` | Status atual do versionamento |
| `sse_algorithm` | Algoritmo de criptografia configurado |

## Seguranca

- Acesso publico bloqueado em todas as dimensoes (ACLs e politicas).
- ACLs desabilitadas via `BucketOwnerEnforced`, forcando controle de acesso somente por politicas IAM/bucket policy.
- Criptografia do lado do servidor habilitada por padrao.
- Nenhuma credencial ou valor sensivel fixo no codigo.

## Validacao

```
terraform init -backend=false
terraform validate
terraform fmt -check
```
