# Security Group Terraform Blueprint

Blueprint Terraform para provisionamento de um Security Group na AWS dentro de uma VPC configuravel.

## Recursos criados

- `aws_security_group.this`: Security Group principal.
- `aws_security_group_rule.ingress`: regras de entrada, definidas via `var.ingress_rules`.
- `aws_security_group_rule.egress`: regras de saida, definidas via `var.egress_rules`.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  environment = "prod"
  name        = "app-sg"

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
    Owner = "time-plataforma"
  }
}
```

## Variaveis principais

| Nome            | Descricao                                              | Obrigatorio | Padrao      |
|-----------------|---------------------------------------------------------|-------------|-------------|
| `vpc_id`        | ID da VPC onde o Security Group sera criado             | Sim         | -           |
| `name`          | Nome do Security Group                                  | Nao         | Gerado      |
| `description`   | Descricao do Security Group                             | Nao         | Ver var     |
| `environment`   | Ambiente usado para nomeacao/tagueamento                | Nao         | `dev`       |
| `ingress_rules` | Lista de regras de entrada                              | Nao         | Ver var     |
| `egress_rules`  | Lista de regras de saida                                 | Nao         | Ver var     |
| `tags`          | Tags adicionais                                          | Nao         | `{}`        |

## Outputs

| Nome                  | Descricao                          |
|-----------------------|-------------------------------------|
| `security_group_id`   | ID do Security Group criado         |
| `security_group_arn`  | ARN do Security Group criado        |
| `security_group_name` | Nome do Security Group criado       |
| `vpc_id`              | ID da VPC associada                 |

## Seguranca

- Nenhuma regra de entrada libera todas as portas (0-65535) para `0.0.0.0/0` por validacao no proprio codigo.
- Os valores padrao de `ingress_rules` restringem o acesso a blocos CIDR privados.
- Nao ha dependencia de credenciais reais ou backend remoto: o modulo pode ser validado com `terraform init -backend=false` e `terraform validate`.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0
