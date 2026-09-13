# Security Group (AWS) - Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS, com regras de entrada e saida totalmente configuraveis via variaveis. O Security Group e associado a uma VPC informada externamente (nao utiliza a VPC default da conta).

## Seguranca por padrao

- `ingress_rules` tem valor padrao de lista vazia: nenhum trafego de entrada e permitido ate que regras sejam explicitamente declaradas.
- `egress_rules` tem valor padrao permitindo todo trafego de saida (`0.0.0.0/0`), seguindo o comportamento convencional de Security Groups na AWS. Ajuste conforme a necessidade de restricao de saida do seu ambiente.
- Nenhum CIDR, credencial ou identificador de conta esta fixado no codigo.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "HTTPS de clientes internos"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "staging"
    Owner       = "team-plataforma"
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
| vpc_id | ID da VPC onde o Security Group sera criado | `string` | - | sim |
| name | Nome do Security Group | `string` | `"sg-default"` | nao |
| description | Descricao do Security Group | `string` | `"Security Group gerenciado via Terraform."` | nao |
| ingress_rules | Lista de regras de entrada | `list(object)` | `[]` | nao |
| egress_rules | Lista de regras de saida | `list(object)` | permite todo trafego de saida | nao |
| tags | Tags adicionais aplicadas ao recurso | `map(string)` | `{}` | nao |

## Outputs

| Nome | Descricao |
|------|-----------|
| security_group_id | ID do Security Group criado |
| security_group_arn | ARN do Security Group criado |
| security_group_name | Nome do Security Group criado |
| security_group_vpc_id | ID da VPC associada ao Security Group |

## Validacao

```
terraform init -backend=false
terraform validate
```
