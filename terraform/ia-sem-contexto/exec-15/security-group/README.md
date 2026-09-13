# Security Group - Blueprint Terraform

Blueprint Terraform para provisionamento de um Security Group na AWS, com o ID da VPC configuravel por variavel. Nao cria nem depende da VPC padrao da conta.

## Caracteristicas

- ID da VPC totalmente configuravel via variavel `vpc_id`.
- Nenhuma porta de entrada aberta por padrao (`ingress_rules` default vazio) — configuracao segura por padrao.
- Regra de saida padrao permitindo todo o trafego outbound (ajustavel via `egress_rules`).
- Validacao de formato dos blocos CIDR informados em `ingress_rules` e `egress_rules`.
- Validacao do formato do `vpc_id`.
- Tags customizaveis via variavel `tags`.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "Allow HTTPS from internal network"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "team-devops"
  }
}
```

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|------|-----------|------|---------|-------------|
| aws_region | Regiao AWS onde os recursos serao provisionados | `string` | `"us-east-1"` | nao |
| vpc_id | ID da VPC onde o Security Group sera provisionado | `string` | - | sim |
| name | Nome do Security Group | `string` | `"sg-default"` | nao |
| description | Descricao do Security Group | `string` | `"Managed by Terraform"` | nao |
| ingress_rules | Lista de regras de entrada | `list(object)` | `[]` | nao |
| egress_rules | Lista de regras de saida | `list(object)` | allow all outbound | nao |
| tags | Tags adicionais | `map(string)` | `{}` | nao |

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

## Boas praticas adotadas

- Nenhuma regra de entrada aberta por padrao, evitando exposicao acidental.
- Validacao de CIDRs e do ID da VPC antes do apply.
- Nao ha valores sensiveis fixos no codigo.
- Uso de `lifecycle.create_before_destroy` para evitar interrupcao de conectividade durante atualizacoes.
