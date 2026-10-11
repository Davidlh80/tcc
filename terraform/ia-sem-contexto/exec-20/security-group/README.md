# Security Group - Blueprint Terraform

Este modulo provisiona um Security Group na AWS dentro de uma VPC existente (criada previamente pelo ambiente de teste), com regras explicitas de entrada e saida, tags configuraveis e outputs relevantes.

## Recursos criados

- `aws_security_group.this`: Security Group com regras de ingress/egress definidas dinamicamente a partir das variaveis `ingress_rules` e `egress_rules`.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS `hashicorp/aws` ~> 5.0
- Uma VPC previamente existente (o `vpc_id` deve ser informado via variavel)

## Uso

```hcl
module "security_group" {
  source = "./"

  region = "us-east-1"
  vpc_id = "vpc-0123456789abcdef0"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "Permite HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite HTTPS de saida"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "exemplo"
  }
}
```

## Variaveis

| Nome            | Descricao                                              | Tipo          | Default                        |
|-----------------|---------------------------------------------------------|---------------|---------------------------------|
| `region`        | Regiao AWS                                               | `string`      | `"us-east-1"`                   |
| `vpc_id`        | ID da VPC onde o Security Group sera criado (obrigatorio)| `string`      | -                                |
| `name`          | Nome do Security Group                                   | `string`      | `"example-sg"`                  |
| `description`   | Descricao do Security Group                              | `string`      | `"Security group gerenciado via Terraform"` |
| `ingress_rules` | Lista de regras de entrada explicitas                    | `list(object)`| ver `variables.tf`              |
| `egress_rules`  | Lista de regras de saida explicitas                       | `list(object)`| ver `variables.tf`              |
| `tags`          | Tags adicionais                                           | `map(string)` | `{}`                             |

## Outputs

| Nome                     | Descricao                                   |
|--------------------------|----------------------------------------------|
| `security_group_id`      | ID do Security Group criado                  |
| `security_group_arn`     | ARN do Security Group criado                 |
| `security_group_name`    | Nome do Security Group criado                |
| `security_group_vpc_id`  | ID da VPC associada ao Security Group        |
| `ingress_rules`          | Regras de entrada aplicadas                  |
| `egress_rules`           | Regras de saida aplicadas                    |

## Consideracoes de seguranca

- Nenhuma regra padrao libera todas as portas (0-65535) para `0.0.0.0/0`.
- As regras de entrada e saida devem ser explicitas, informando protocolo, portas e CIDRs especificos.
- Revise os CIDRs de origem/destino antes de aplicar em ambientes produtivos, restringindo ao minimo necessario (principio do menor privilegio).

## Validacao

```bash
terraform init -backend=false
terraform validate
```
