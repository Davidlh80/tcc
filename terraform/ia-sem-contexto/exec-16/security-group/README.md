# Security Group Terraform Module

Esta blueprint provisiona um AWS Security Group com regras explicitas de entrada e saida, dentro de uma VPC configuravel.

## Recursos criados

- `aws_security_group.this`: Security Group principal.
- `aws_security_group_rule.ingress`: Regras de entrada, definidas via `var.ingress_rules`.
- `aws_security_group_rule.egress`: Regras de saida, definidas via `var.egress_rules`.

## Uso

```
module "security_group" {
  source = "./"

  name        = "minha-app-sg"
  description = "Security Group da aplicacao"
  vpc_id      = "vpc-0123456789abcdef0"

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
    Environment = "dev"
  }
}
```

## Variaveis principais

| Nome | Descricao | Tipo | Default |
|---|---|---|---|
| `name` | Nome do Security Group | `string` | `"app-sg"` |
| `description` | Descricao do Security Group | `string` | `"Security Group gerenciado via Terraform"` |
| `vpc_id` | ID da VPC (obrigatorio) | `string` | - |
| `ingress_rules` | Lista de regras de entrada | `list(object(...))` | regra HTTPS interna |
| `egress_rules` | Lista de regras de saida | `list(object(...))` | regra HTTPS saida |
| `tags` | Tags adicionais | `map(string)` | `{}` |
| `region` | Regiao AWS | `string` | `"us-east-1"` |

## Outputs

| Nome | Descricao |
|---|---|
| `security_group_id` | ID do Security Group criado |
| `security_group_arn` | ARN do Security Group criado |
| `security_group_name` | Nome do Security Group criado |
| `vpc_id` | ID da VPC associada |

## Seguranca

- Nenhuma regra de entrada padrao libera acesso irrestrito (`0.0.0.0/0`); uma `validation` bloqueia esse valor em `ingress_rules`.
- O `vpc_id` deve apontar para a VPC criada pelo ambiente de teste, nunca para a VPC default da conta.
- Regras de entrada e saida sao explicitas e documentadas via `description` em cada bloco.

## Validacao

```
terraform init -backend=false
terraform validate
```
