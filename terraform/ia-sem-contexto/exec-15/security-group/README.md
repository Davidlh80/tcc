# Security Group - Terraform Blueprint

Blueprint Terraform para provisionamento de um Security Group na AWS, com regras explicitas de entrada e saida, dentro de uma VPC configuravel.

## Recursos criados

- `aws_security_group.this`: Security Group associado a uma VPC informada via variavel, com regras de ingress/egress definidas dinamicamente e tags aplicadas.

## Requisitos

- Terraform >= 1.3.0
- Provider AWS (`hashicorp/aws`) ~> 5.0

## Variaveis principais

| Nome            | Descricao                                                             | Tipo          | Default                        |
|-----------------|------------------------------------------------------------------------|---------------|---------------------------------|
| `region`        | Regiao AWS utilizada pelo provider                                     | `string`      | `"us-east-1"`                   |
| `vpc_id`        | ID da VPC onde o Security Group sera criado (obrigatorio)              | `string`      | -                                |
| `name`          | Nome do Security Group                                                 | `string`      | `"sg-managed"`                  |
| `description`   | Descricao do Security Group                                            | `string`      | `"Security group gerenciado via Terraform"` |
| `ingress_rules` | Lista de regras de entrada (descricao, portas, protocolo, CIDRs)       | `list(object)`| Regras HTTPS/SSH restritas a `10.0.0.0/16` |
| `egress_rules`  | Lista de regras de saida (descricao, portas, protocolo, CIDRs)         | `list(object)`| Regra HTTPS de saida para `0.0.0.0/0` |
| `tags`          | Tags adicionais aplicadas ao recurso                                    | `map(string)` | `{}`                            |

A variavel `ingress_rules` possui validacao que impede o uso do CIDR irrestrito `0.0.0.0/0` em regras de entrada.

## Outputs

| Nome                     | Descricao                                 |
|--------------------------|---------------------------------------------|
| `security_group_id`      | ID do Security Group criado                |
| `security_group_arn`     | ARN do Security Group criado                |
| `security_group_name`    | Nome do Security Group criado               |
| `security_group_vpc_id`  | ID da VPC associada ao Security Group       |

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-xxxxxxxxxxxxxxxxx"
  name   = "sg-app"

  ingress_rules = [
    {
      description = "Permite HTTPS da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.10.0/24"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Validacao local

```
terraform init -backend=false
terraform validate
```
