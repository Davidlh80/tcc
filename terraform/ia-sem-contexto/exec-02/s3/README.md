# Blueprint Terraform - Bucket Amazon S3

Esta blueprint provisiona um bucket Amazon S3 seguro por padrao, cobrindo:

- Criacao do bucket (`aws_s3_bucket`).
- Desabilitacao de ACLs via `aws_s3_bucket_ownership_controls` (`BucketOwnerEnforced`).
- Bloqueio total de acesso publico via `aws_s3_bucket_public_access_block`.
- Criptografia do lado do servidor configuravel (`AES256` ou `aws:kms`) via `aws_s3_bucket_server_side_encryption_configuration`.
- Versionamento configuravel por variavel via `aws_s3_bucket_versioning`.
- Tags padrao mescladas com tags customizadas.

## Arquivos

- `main.tf`: recursos do bucket e suas configuracoes de seguranca.
- `variables.tf`: variaveis de entrada configuraveis.
- `outputs.tf`: outputs relevantes do bucket provisionado.
- `versions.tf`: requisitos de versao do Terraform e do provider AWS.

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `aws_region` | Regiao AWS do bucket | `us-east-1` |
| `bucket_name` | Nome unico do bucket (obrigatorio) | - |
| `force_destroy` | Permite destruir bucket com objetos | `false` |
| `enable_versioning` | Habilita versionamento | `true` |
| `sse_algorithm` | Algoritmo de criptografia (`AES256` ou `aws:kms`) | `AES256` |
| `kms_key_arn` | ARN da chave KMS (usado somente se `sse_algorithm = "aws:kms"`) | `null` |
| `tags` | Tags adicionais mescladas com as padrao | `{}` |

## Uso

```
terraform init -backend=false
terraform validate
terraform plan -var="bucket_name=meu-bucket-exemplo"
```

## Observacoes de seguranca

- Acesso publico e bloqueado por padrao em todas as dimensoes (ACLs e politicas).
- ACLs de objeto sao desabilitadas em favor do controle de propriedade do bucket (`BucketOwnerEnforced`).
- Criptografia do lado do servidor e obrigatoria, com suporte a chaves gerenciadas pelo KMS.
- `force_destroy` permanece `false` por padrao para evitar perda acidental de dados.
- Nenhuma credencial real e necessaria para `terraform init -backend=false` e `terraform validate`.
