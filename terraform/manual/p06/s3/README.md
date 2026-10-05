# p06 / s3

Bucket S3 privado, com versionamento, criptografia KMS e bloqueio de acesso publico. Os logs de acesso vao para um segundo bucket, tambem privado. Este diretorio e um modulo raiz independente.

## Arquivos

- `versions.tf` — versao do Terraform e provider AWS
- `variables.tf` — valores configuraveis
- `main.tf` — buckets, criptografia e politica
- `outputs.tf` — nomes, ARN e chave KMS

## Uso

```bash
terraform init
terraform fmt
terraform validate
```

`bucket_name` e `log_bucket_name` nao tem valor padrao:

```bash
terraform plan \
  -var="bucket_name=nome-do-bucket" \
  -var="log_bucket_name=nome-do-bucket-logs"
```
