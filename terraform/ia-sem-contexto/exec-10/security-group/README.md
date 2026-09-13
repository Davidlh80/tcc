# Security Group (AWS)

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, com regras de entrada e saida totalmente configuraveis via variaveis.

## Recursos criados

- `aws_security_group.this`: Security Group associado a VPC informada em `var.vpc_id`.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0
- Uma VPC existente (o ID deve ser informado via `var.vpc_id`)

## Variaveis principais

| Nome            | Descricao                                              | Tipo   | Padrao                                   |
|-----------------|---------------------------------------------------------|--------|-------------------------------------------|
| `vpc_id`        | ID da VPC onde o Security Group sera criado (obrigatorio) | string | -                                          |
| `name`          | Nome do Security Group                                  | string | `example-sg`                              |
| `description`   | Descricao do Security Group                              | string | `Security Group gerenciado via Terraform.` |
| `ingress_rules` | Lista de regras de entrada                               | list(object) | `[]` (nenhuma entrada permitida por padrao) |
| `egress_rules`  | Lista de regras de saida                                 | list(object) | libera todo trafego de saida (`0.0.0.0/0`) |
| `tags`          | Tags adicionais                                          | map(string) | `{}`                                    |

Por padrao, nenhuma regra de entrada e permitida (postura segura), sendo necessario declarar explicitamente as portas e origens desejadas em `ingress_rules`.

## Exemplo de uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "HTTPS de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

## Outputs

| Nome                  | Descricao                              |
|-----------------------|------------------------------------------|
| `security_group_id`   | ID do Security Group criado              |
| `security_group_arn`  | ARN do Security Group criado             |
| `security_group_name` | Nome do Security Group criado            |
| `vpc_id`               | ID da VPC associada ao Security Group    |

## Validacao

```
terraform init -backend=false
terraform validate
```
