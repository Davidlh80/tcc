# Security Group Blueprint

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, informada via variavel.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider `hashicorp/aws` ~> 5.0
- Um `vpc_id` valido de uma VPC ja existente no ambiente de teste

## Uso

module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security group da aplicacao"

  ingress_rules = [
    {
      description = "HTTPS interno"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saida HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "test"
  }
}

## Variaveis

| Nome          | Descricao                                            | Tipo         | Default                       |
|---------------|-------------------------------------------------------|--------------|--------------------------------|
| vpc_id        | ID da VPC onde o Security Group sera criado           | string       | n/a (obrigatorio)             |
| name          | Nome do Security Group                                | string       | "sg-managed-by-terraform"     |
| description   | Descricao do Security Group                           | string       | "Security group gerenciado..."|
| ingress_rules | Lista de regras de entrada                            | list(object) | []                             |
| egress_rules  | Lista de regras de saida                              | list(object) | []                             |
| tags          | Tags adicionais                                       | map(string)  | {}                              |

## Outputs

| Nome     | Descricao                                    |
|----------|-----------------------------------------------|
| id       | ID do Security Group criado                   |
| arn      | ARN do Security Group criado                  |
| name     | Nome do Security Group criado                 |
| vpc_id   | ID da VPC associada                           |
| owner_id | ID da conta AWS proprietaria do recurso       |

## Seguranca

- Por padrao, nenhuma regra de ingress ou egress e criada (`[]`), seguindo o principio de menor privilegio: o Security Group nasce fechado e as regras sao adicionadas explicitamente pelo consumidor do modulo.
- Ha validacao que bloqueia a liberacao das portas 22 (SSH) e 3389 (RDP) para `0.0.0.0/0` em `ingress_rules`.
- `revoke_rules_on_delete = true` garante que as regras sejam removidas antes da exclusao do Security Group, evitando problemas de dependencia.
- Nenhuma credencial real e necessaria para `terraform init -backend=false` e `terraform validate`.
