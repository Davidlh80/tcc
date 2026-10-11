# Security Group - Blueprint Terraform

Blueprint Terraform para provisionamento de um AWS Security Group dentro de uma VPC configuravel, com regras explicitas de entrada e saida.

## Recursos criados

- `aws_security_group.this`: Security Group associado a VPC informada em `var.vpc_id`, sem regras de entrada liberadas por padrao e com uma unica regra de saida HTTPS (443/tcp) habilitada.

## Requisitos

- Terraform >= 1.3.0
- Provider AWS `~> 5.0`
- Uma VPC previamente existente (o ID deve ser informado em `vpc_id`)

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "Permite HTTPS da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "test"
    Project     = "tcc"
  }
}
```

## Inputs

| Nome          | Descricao                                                                 | Tipo           | Default                                    |
|---------------|----------------------------------------------------------------------------|----------------|---------------------------------------------|
| aws_region    | Regiao AWS onde os recursos serao provisionados                           | string         | "us-east-1"                                 |
| vpc_id        | ID da VPC onde o Security Group sera criado                               | string         | (obrigatorio)                               |
| name          | Nome do Security Group                                                    | string         | "tcc-security-group"                        |
| description   | Descricao do Security Group                                               | string         | "Security group gerenciado via Terraform"   |
| ingress_rules | Lista de regras de entrada explicitas                                     | list(object)   | []                                          |
| egress_rules  | Lista de regras de saida explicitas                                       | list(object)   | regra HTTPS (443/tcp) para 0.0.0.0/0        |
| tags          | Tags adicionais aplicadas ao Security Group                               | map(string)    | {}                                          |

## Outputs

| Nome                 | Descricao                                 |
|----------------------|---------------------------------------------|
| security_group_id    | ID do Security Group criado                |
| security_group_arn   | ARN do Security Group criado               |
| security_group_name  | Nome do Security Group criado              |
| vpc_id               | ID da VPC associada ao Security Group      |

## Seguranca

- Nenhuma regra de entrada e criada por padrao; o consumidor do modulo deve declarar explicitamente as regras necessarias via `ingress_rules`.
- Uma validacao bloqueia regras de entrada que liberem as portas 22 (SSH) ou 3389 (RDP) para `0.0.0.0/0`.
- A regra de saida padrao restringe o trafego liberado por padrao apenas a porta 443/tcp, evitando egress irrestrito desnecessario.
