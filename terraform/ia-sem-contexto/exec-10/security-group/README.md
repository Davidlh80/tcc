# Security Group — Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS, pronto para ser anexado a recursos dentro de uma VPC gerenciada pelo proprio ambiente de teste (nao a VPC padrao da conta).

## Recursos criados

- `aws_security_group.this`: Security Group com regras de entrada e saida configuraveis via variaveis, sem abertura irrestrita por padrao (nenhuma regra de entrada e criada automaticamente).

## Variaveis principais

| Nome | Descricao | Padrao |
|---|---|---|
| `vpc_id` | ID da VPC onde o Security Group sera criado (obrigatorio) | - |
| `name` | Nome do Security Group | `tcc-security-group` |
| `description` | Descricao do Security Group | `Security group gerenciado via Terraform` |
| `ingress_rules` | Lista de regras de entrada explicitas | `[]` |
| `egress_rules` | Lista de regras de saida explicitas | HTTPS (443/tcp) liberado para saida |
| `tags` | Tags adicionais | `{}` |

### Formato de `ingress_rules` / `egress_rules`

```
[
  {
    description = "Permite acesso HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
]
```

## Outputs

| Nome | Descricao |
|---|---|
| `security_group_id` | ID do Security Group criado |
| `security_group_arn` | ARN do Security Group criado |
| `security_group_name` | Nome do Security Group criado |
| `vpc_id` | ID da VPC associada |

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Permite acesso HTTPS interno"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "test"
  }
}
```

## Validacao

```
terraform init -backend=false
terraform validate
```
