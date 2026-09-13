# Security Group Blueprint

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC informada via variavel.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-xxxxxxxx"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "Allow HTTPS from internal network"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Inputs

| Nome           | Descricao                                          | Tipo          | Default                                   |
|----------------|-----------------------------------------------------|---------------|--------------------------------------------|
| aws_region     | Regiao AWS onde o Security Group sera criado         | string        | "us-east-1"                                |
| vpc_id         | ID da VPC onde o Security Group sera criado          | string        | (obrigatorio)                              |
| name           | Nome do Security Group                               | string        | "app-sg"                                   |
| description    | Descricao do Security Group                          | string        | "Managed by Terraform"                     |
| ingress_rules  | Lista de regras de entrada                           | list(object)  | []                                          |
| egress_rules   | Lista de regras de saida                             | list(object)  | Allow all outbound traffic (0.0.0.0/0)     |
| tags           | Tags adicionais                                      | map(string)   | {}                                          |

## Outputs

| Nome                 | Descricao                                  |
|----------------------|---------------------------------------------|
| security_group_id    | ID do Security Group criado                 |
| security_group_arn   | ARN do Security Group criado                |
| security_group_name  | Nome do Security Group criado               |
| vpc_id               | ID da VPC associada ao Security Group       |

## Notas de seguranca

- Por padrao, nenhuma regra de entrada e criada (`ingress_rules = []`), evitando exposicao acidental de portas.
- Sempre restrinja `cidr_blocks` das regras de entrada ao minimo necessario, evitando o uso de `0.0.0.0/0` em portas sensiveis.
- Revise a regra de saida padrao (`egress_rules`) caso seja necessario restringir trafego de saida.
