# Security Group Blueprint (AWS / Terraform)

Este modulo provisiona um AWS Security Group associado a uma VPC existente, com regras de entrada e saida totalmente configuraveis via variaveis.

## Configuracao segura por padrao

- Nenhuma regra de ingress e criada por padrao (`ingress_rules = []`) — nenhuma porta fica aberta ate que o consumidor do modulo defina explicitamente as regras necessarias.
- A regra de egress padrao permite todo o trafego de saida (`0.0.0.0/0`), seguindo o comportamento padrao mais comum em ambientes AWS. Ajuste `egress_rules` caso deseje restringir o trafego de saida.
- `vpc_id` e obrigatorio e validado com uma expressao regular no formato `vpc-xxxxxxxx`.
- Todos os `cidr_blocks` informados em `ingress_rules` e `egress_rules` sao validados quanto ao formato CIDR.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name_prefix = "web"
  description = "Security Group para servidores web"

  ingress_rules = [
    {
      description = "HTTPS publico"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH restrito a rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]

  tags = {
    Environment = "production"
    Owner       = "team-infra"
  }
}
```

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|------|-----------|------|--------|-------------|
| aws_region | Regiao AWS onde os recursos serao provisionados | `string` | `"us-east-1"` | nao |
| vpc_id | ID da VPC onde o Security Group sera criado | `string` | n/a | sim |
| name_prefix | Prefixo usado para nomear o Security Group | `string` | `"app"` | nao |
| description | Descricao do Security Group | `string` | `"Managed by Terraform"` | nao |
| ingress_rules | Lista de regras de entrada | `list(object)` | `[]` | nao |
| egress_rules | Lista de regras de saida | `list(object)` | permite todo trafego de saida | nao |
| tags | Tags adicionais aplicadas ao Security Group | `map(string)` | `{}` | nao |

## Outputs

| Nome | Descricao |
|------|-----------|
| security_group_id | ID do Security Group criado |
| security_group_arn | ARN do Security Group criado |
| security_group_name | Nome do Security Group criado |
| vpc_id | ID da VPC associada ao Security Group |

## Validacao

```bash
terraform init -backend=false
terraform validate
```
