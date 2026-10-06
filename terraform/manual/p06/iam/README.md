# p06 / iam

Role IAM com permissao de leitura em um prefixo de bucket S3. Este diretorio e um modulo raiz independente.

## Arquivos

- `versions.tf` — versao do Terraform e provider AWS
- `variables.tf` — valores configuraveis
- `main.tf` — role e politica
- `outputs.tf` — nome e ARN da role

## Uso

```bash
terraform init
terraform fmt
terraform validate
```

`bucket_name` nao tem valor padrao. Passe o nome na validacao do plano:

```bash
terraform plan -var="bucket_name=nome-do-bucket"
```
