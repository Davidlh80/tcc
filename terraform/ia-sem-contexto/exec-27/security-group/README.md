# Security Group - Blueprint Terraform

Este modulo provisiona um AWS Security Group com regras explicitas de entrada e saida, associado a uma VPC configuravel via variavel.

## Recursos criados

- `aws_security_group.this`

## Pre-requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0
- Uma VPC previamente criada (o `vpc_id` deve ser informado; nao utiliza a VPC padrao da conta)

## Uso

```
module "security_group" {
  source = "./"

  name        = "sg-app"
  description = "Security Group para a aplicacao"
  vpc_id      = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description      = "HTTPS interno"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/16"]
      ipv6_cidr_blocks = []
    }
  ]

  egress_rules = [
    {
      description      = "Saida HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Variaveis principais

| Nome            | Descricao                                   | Tipo           | Obrigatoria |
|-----------------|----------------------------------------------|----------------|-------------|
| name            | Nome do Security Group                       | string         | Nao         |
| description     | Descricao do Security Group                  | string         | Nao         |
| vpc_id          | ID da VPC onde o SG sera criado               | string         | Sim         |
| ingress_rules   | Lista de regras de entrada explicitas         | list(object)   | Nao         |
| egress_rules    | Lista de regras de saida explicitas           | list(object)   | Nao         |
| tags            | Tags adicionais                               | map(string)    | Nao         |

## Outputs

| Nome                  | Descricao                              |
|-----------------------|------------------------------------------|
| security_group_id     | ID do Security Group criado              |
| security_group_arn    | ARN do Security Group criado             |
| security_group_name   | Nome do Security Group criado            |
| vpc_id                | ID da VPC associada                      |

## Seguranca

- Nenhuma regra abre todas as portas (`0.0.0.0/0` em todas as portas) por padrao.
- As regras de entrada e saida devem ser revisadas e ajustadas conforme o principio de menor privilegio antes do uso em producao.
- O `vpc_id` deve apontar para uma VPC especifica do ambiente, nunca para a VPC padrao da conta.
