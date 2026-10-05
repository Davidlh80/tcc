# Security Group — p03

Cria um Security Group em uma VPC existente. Cada combinação única de porta e
CIDR gera uma regra TCP de entrada e outra de saída, usando recursos separados.
As mesmas portas e redes são usadas nas duas direções. As portas devem ser inteiros
entre 1 e 65535; os CIDRs devem ser redes IPv4 válidas e não podem usar `/0`.

## Uso

Requer Terraform >= 1.9.0 e AWS Provider 5.100.0. Configure as credenciais pelos
mecanismos padrão da AWS, como `AWS_PROFILE`, e crie `terraform.tfvars`:

```hcl
aws_region          = "us-east-1"
environment         = "dev"
security_group_name = "tcc-p03-dev-app"
vpc_id              = "vpc-0123456789abcdef0"
allowed_ports       = [443]
allowed_cidrs       = ["10.0.1.0/24"]
tags                = { Project = "tcc" }
```

Substitua a VPC e os CIDRs pelos valores do ambiente.

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Após revisar o plano, use `terraform apply` para provisionar.

## Variáveis e outputs

Todas as variáveis do exemplo são obrigatórias, exceto `tags` (padrão `{}`).
Não há regra de saída irrestrita. O tráfego de resposta é permitido pelo
comportamento stateful dos Security Groups. As tags `Name`, `Environment` e
`ManagedBy = "Terraform"` têm precedência sobre as tags adicionais.

Outputs: `security_group_id`, `security_group_arn` e `security_group_name`.

Referências consultadas via Context7: [Security Group](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group),
[ingress rule](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/vpc_security_group_ingress_rule)
e [egress rule](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/vpc_security_group_egress_rule).
