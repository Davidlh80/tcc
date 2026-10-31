# Terraform - S3

Cria um bucket S3 com bloqueio de acesso público, criptografia SSE-S3, versionamento configurável e tags.

## Uso

Configure as variáveis em `terraform.tfvars` (não inclua segredos):

```hcl
aws_region        = "us-east-1"
bucket_name       = "meu-bucket-unico-123456"
environment       = "dev"
versioning_enabled = true
tags = {
  Project = "experimento"
  Owner   = "platform-team"
}
```

Execute:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

O nome do bucket deve ser globalmente único.
