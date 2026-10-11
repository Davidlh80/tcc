# Security Group — Blueprint Terraform

Blueprint Terraform para provisionamento de um Security Group na AWS, com regras explícitas de entrada e saída, dentro de uma VPC configurável.

## Recursos criados

- `aws_security_group.this` — Security Group com regras de ingress/egress definidas dinamicamente a partir de variáveis.

## Pré-requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0
- Um `vpc_id` válido de uma VPC existente (não a VPC default da conta).

## Variáveis principais

| Nome            | Descrição                                           | Tipo          | Default           |
|-----------------|------------------------------------------------------|---------------|--------------------|
| `aws_region`    | Região AWS                                           | `string`      | `"us-east-1"`      |
| `vpc_id`        | ID da VPC onde o SG será criado                      | `string`      | (obrigatório)      |
| `name`          | Nome do Security Group                               | `string`      | `"app-sg"`         |
| `description`   | Descrição do Security Group                          | `string`      | descrição padrão   |
| `ingress_rules` | Lista de regras de entrada (description, portas, protocolo, CIDRs) | `list(object)` | HTTPS (443) a partir de `10.0.0.0/8` |
| `egress_rules`  | Lista de regras de saída (description, portas, protocolo, CIDRs)   | `list(object)` | HTTPS (443) para `0.0.0.0/0` |
| `tags`          | Tags adicionais                                      | `map(string)` | `{}`               |

As regras padrão evitam abertura irrestrita de entrada; ajuste `ingress_rules` e `egress_rules` conforme as portas e origens necessárias ao seu caso de uso.

## Outputs

- `security_group_id`
- `security_group_arn`
- `security_group_name`
- `vpc_id`
- `ingress_rules_count`
- `egress_rules_count`

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "web-sg"

  ingress_rules = [
    {
      description = "HTTP interno"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Validação

```
terraform init -backend=false
terraform validate
```
