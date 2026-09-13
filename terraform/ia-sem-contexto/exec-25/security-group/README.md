# Security Group (AWS)

Blueprint Terraform para provisionamento de um `aws_security_group` associado a uma VPC configuravel, com regras de entrada e saida definidas por variaveis.

## Recursos criados

- `aws_security_group.this`: Security Group principal.
- `aws_security_group_rule.ingress`: regras de entrada, uma para cada item de `var.ingress_rules`.
- `aws_security_group_rule.egress`: regras de saida, uma para cada item de `var.egress_rules`.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "sg-aplicacao"

  ingress_rules = [
    {
      description = "Acesso HTTPS interno"
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
    Ambiente = "producao"
  }
}
```

## Variaveis

| Nome            | Descricao                                             | Tipo           | Default                          |
|-----------------|--------------------------------------------------------|----------------|-----------------------------------|
| `vpc_id`        | ID da VPC onde o Security Group sera criado            | `string`       | (obrigatorio)                     |
| `name`          | Nome do Security Group                                  | `string`       | `"sg-app"`                        |
| `description`   | Descricao do Security Group                             | `string`       | `"Security Group gerenciado via Terraform"` |
| `ingress_rules` | Lista de regras de entrada                              | `list(object)` | regra HTTPS interna (`10.0.0.0/16`) |
| `egress_rules`  | Lista de regras de saida                                 | `list(object)` | regra HTTPS de saida (`0.0.0.0/0`) |
| `tags`          | Tags adicionais aplicadas ao recurso                     | `map(string)`  | `{}`                               |

## Outputs

| Nome                  | Descricao                              |
|-----------------------|------------------------------------------|
| `security_group_id`   | ID do Security Group criado              |
| `security_group_arn`  | ARN do Security Group criado             |
| `security_group_name` | Nome do Security Group criado            |
| `vpc_id`              | ID da VPC associada ao Security Group    |

## Seguranca

- Nao ha regras abertas (`0.0.0.0/0`) por padrao para portas de entrada, exceto quando explicitamente definido pelo consumidor do modulo.
- Uma validacao bloqueia a criacao de regras de ingress com origem `0.0.0.0/0` para portas diferentes de `443`.
- Todas as origens (CIDRs), portas e protocolos sao configuraveis via variaveis, evitando valores fixos sensiveis no codigo.
