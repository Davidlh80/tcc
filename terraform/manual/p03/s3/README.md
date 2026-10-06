# S3 — p03

Cria um bucket privado com os quatro bloqueios de acesso público, criptografia
SSE-S3 (`AES256`) e versionamento habilitado por padrão. `versioning_enabled = false`
suspende o versionamento; versões existentes são preservadas.

## Uso

Requer Terraform >= 1.9.0 e AWS Provider 5.100.0. Configure as credenciais pelos
mecanismos padrão da AWS, como `AWS_PROFILE`, e crie `terraform.tfvars`:

```hcl
aws_region         = "us-east-1"
environment        = "dev"
bucket_name        = "tcc-p03-dev-documents-123456789012"
versioning_enabled = true
tags               = { Project = "tcc" }
```

Escolha um nome de bucket globalmente único.

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Após revisar o plano, use `terraform apply` para provisionar.

## Variáveis e outputs

| Variável | Padrão |
| --- | --- |
| `aws_region` | Obrigatória |
| `environment` | Obrigatória |
| `bucket_name` | Obrigatória |
| `versioning_enabled` | `true` |
| `force_destroy` | `false` |
| `tags` | `{}` |

`force_destroy = true` permite excluir o bucket junto com seus objetos e versões.
As tags `Name`, `Environment` e `ManagedBy = "Terraform"` têm precedência sobre
as tags adicionais.

Outputs: `bucket_name`, `bucket_arn` e `bucket_id`.

Referências consultadas via Context7: [public access block](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/s3_bucket_public_access_block),
[encryption](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/s3_bucket_server_side_encryption_configuration)
e [versioning](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/s3_bucket_versioning).
