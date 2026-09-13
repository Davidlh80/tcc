# Security Group

Blueprint Terraform para provisionamento de um AWS Security Group dentro de uma VPC existente, com regras de entrada e saida totalmente configuraveis via variaveis.

## Recursos criados

- `aws_security_group.this`

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security group da aplicacao"

  ingress_rules = [
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

## Variaveis

| Nome            | Descricao                                    | Tipo          | Default              |
| --------------- | --------------------------------------------- | ------------- | -------------------- |
| `vpc_id`        | ID da VPC onde o Security Group sera criado    | `string`      | n/a (obrigatorio)     |
| `aws_region`    | Regiao AWS onde os recursos serao provisionados | `string`      | `"us-east-1"`         |
| `name`          | Nome do Security Group                         | `string`      | `"sg-default"`        |
| `description`   | Descricao do Security Group                    | `string`      | `"Managed by Terraform"` |
| `ingress_rules` | Lista de regras de entrada                     | `list(object)`| ver `variables.tf`    |
| `egress_rules`  | Lista de regras de saida                       | `list(object)`| ver `variables.tf`    |
| `tags`          | Tags adicionais                                | `map(string)` | `{}`                  |

## Outputs

| Nome                  | Descricao                                  |
| --------------------- | ------------------------------------------- |
| `security_group_id`   | ID do Security Group criado                 |
| `security_group_arn`  | ARN do Security Group criado                |
| `security_group_name` | Nome do Security Group criado               |
| `vpc_id`              | ID da VPC associada                         |
| `owner_id`            | ID da conta AWS proprietaria do recurso     |

## Boas praticas de seguranca

- Evite CIDRs amplos (`0.0.0.0/0`) em regras de entrada; restrinja as origens ao minimo necessario.
- Prefira portas especificas em vez de faixas amplas.
- Revise as regras de saida padrao caso a aplicacao exija restricoes adicionais (ex.: negar saida irrestrita).
- Utilize tags consistentes para rastreabilidade e auditoria dos recursos.

## Validacao

```
terraform init -backend=false
terraform validate
```
