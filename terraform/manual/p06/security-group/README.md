# p06 / security-group

Security group com entrada apenas na porta da aplicacao, restrita aos CIDRs informados, e saida somente em HTTPS. Este diretorio e um modulo raiz independente.

## Arquivos

- `versions.tf` — versao do Terraform e provider AWS
- `variables.tf` — valores configuraveis
- `main.tf` — security group e regras
- `outputs.tf` — ID e ARN do security group

## Uso

```bash
terraform init
terraform fmt
terraform validate
```

`vpc_id` nao tem valor padrao:

```bash
terraform plan -var="vpc_id=vpc-0123456789abcdef0"
```
