# IAM — p03

Cria uma role, uma policy de permissões e o vínculo entre elas. A trust policy
aceita um principal IAM específico, informado por ARN. As ações devem ser
explícitas, e os recursos devem ser ARNs delimitados; sufixos como `bucket/*`
são permitidos para acessar objetos de um bucket específico.
O nome do bucket deve ser completo: `bucket*` e `bucket*/*` são rejeitados.

## Uso

Requer Terraform >= 1.9.0 e AWS Provider 5.100.0. Configure as credenciais pelos
mecanismos padrão da AWS, como `AWS_PROFILE`, e crie `terraform.tfvars`:

```hcl
aws_region            = "us-east-1"
environment           = "dev"
policy_name           = "tcc-p03-s3-read"
role_name             = "tcc-p03-s3-reader"
trusted_principal_arn = "arn:aws:iam::123456789012:role/application"
allowed_actions       = ["s3:GetObject"]
allowed_resources     = ["arn:aws:s3:::tcc-p03-documents/*"]
tags                  = { Project = "tcc" }
```

Substitua o principal por uma role ou usuário existente na sua conta, ou pelo
ARN raiz de uma conta específica. Ajuste os recursos ao acesso necessário.

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Após revisar o plano, use `terraform apply` para provisionar.

## Variáveis e outputs

Todas as variáveis do exemplo são obrigatórias, exceto `tags` (padrão `{}`).
As tags `Environment` e `ManagedBy = "Terraform"` são obrigatórias e têm
precedência sobre as tags adicionais.

Outputs: `policy_name`, `policy_arn`, `policy_id`, `role_name` e `role_arn`.

Referências consultadas via Context7: [IAM role](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role),
[policy document](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/data-sources/iam_policy_document)
e [role policy attachment](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role_policy_attachment).
