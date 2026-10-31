# Terraform - IAM

Cria uma policy IAM, uma role com trust policy restrita e anexa a policy à role.

## Uso

Exemplo de `terraform.tfvars` para uma workload EC2. Ajuste ações, ARNs e principal ao caso real:

```hcl
aws_region                    = "us-east-1"
policy_name                   = "app-dev-s3-read"
role_name                     = "app-dev-ec2-role"
environment                   = "dev"
trusted_principal_type        = "Service"
trusted_principal_identifiers = ["ec2.amazonaws.com"]
allowed_actions               = ["s3:GetObject"]
allowed_resources             = ["arn:aws:s3:::meu-bucket-unico-123456/*"]
tags = {
  Project = "experimento"
  Owner   = "platform-team"
}
```

Execute `terraform init`, `terraform fmt -recursive`, `terraform validate`, `terraform plan` e `terraform apply`.

Use o menor conjunto de ações e recursos possível. Não use `*` como principal, ação ou recurso. Para uma role EC2 ser usada por instâncias, pode ser necessário criar também um instance profile, conforme o fluxo de implantação.
