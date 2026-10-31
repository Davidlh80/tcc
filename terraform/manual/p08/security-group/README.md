# Terraform - Security Group

Cria um Security Group em uma VPC existente com regras de entrada e saída configuráveis.

## Uso

Exemplo de `terraform.tfvars`:

```hcl
aws_region          = "us-east-1"
security_group_name = "app-dev-sg"
vpc_id              = "vpc-0123456789abcdef0"
environment         = "dev"

ingress_rules = [
  {
    description = "HTTPS apenas da rede corporativa"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }
]

egress_rules = [
  {
    description = "HTTPS para serviços necessários"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

tags = {
  Project = "experimento"
  Owner   = "platform-team"
}
```

Execute `terraform init`, `terraform fmt -recursive`, `terraform validate`, `terraform plan` e `terraform apply`.

O template não abre portas de entrada por padrão. A regra de saída padrão permite apenas TCP/443; substitua-a conforme as necessidades reais da aplicação. Revise as regras antes de aplicar.
