# Blueprint Terraform — Bucket Amazon S3

Blueprint para provisionamento de um bucket Amazon S3 com configuracoes seguras por padrao: bloqueio total de acesso publico, criptografia do lado do servidor, versionamento configuravel, ownership controls e tags padronizadas.

## Recursos criados

- `aws_s3_bucket` — bucket S3 principal.
- `aws_s3_bucket_public_access_block` — bloqueia qualquer forma de acesso publico ao bucket.
- `aws_s3_bucket_versioning` — habilita ou suspende o versionamento de objetos conforme variavel.
- `aws_s3_bucket_server_side_encryption_configuration` — aplica criptografia padrao (`AES256` ou `aws:kms`) a todos os objetos.
- `aws_s3_bucket_ownership_controls` — forca o modelo `BucketOwnerEnforced`, desabilitando ACLs.

## Requisitos

- Terraform >= 1.5.0
- Provider `hashicorp/aws` >= 5.0
- Credenciais AWS validas apenas para `terraform apply` (nao sao necessarias para `init -backend=false` e `validate`).

## Uso

```
terraform init -backend=false
terraform validate
terraform plan -var="bucket_name=meu-bucket-exemplo"
terraform apply -var="bucket_name=meu-bucket-exemplo"
```

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `region` | Regiao AWS | `us-east-1` |
| `bucket_name` | Nome unico do bucket (obrigatorio) | — |
| `environment` | Ambiente para tagueamento | `dev` |
| `enable_versioning` | Habilita versionamento | `true` |
| `force_destroy` | Permite destruir bucket com objetos | `false` |
| `sse_algorithm` | Algoritmo de criptografia (`AES256` ou `aws:kms`) | `AES256` |
| `kms_key_arn` | ARN da chave KMS (quando `aws:kms`) | `null` |
| `bucket_key_enabled` | Habilita S3 Bucket Key para `aws:kms` | `true` |
| `tags` | Tags adicionais | `{}` |

## Outputs

- `bucket_id`
- `bucket_arn`
- `bucket_domain_name`
- `bucket_regional_domain_name`
- `versioning_status`
- `sse_algorithm`

## Observacoes de seguranca

- Acesso publico e bloqueado em todas as camadas (ACLs e politicas) por padrao.
- ACLs sao desabilitadas via `BucketOwnerEnforced`, seguindo a recomendacao atual da AWS.
- Para dados sensiveis, recomenda-se utilizar `sse_algorithm = "aws:kms"` com uma chave KMS gerenciada pelo cliente (CMK).
- Nenhum valor sensivel ou credencial esta fixado no codigo; todos os parametros configuraveis sao expostos via variaveis.
