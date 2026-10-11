# Security Group (AWS)

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC configuravel por variavel. Nao cria nem depende da VPC default da conta.

## Caracteristicas

- Security Group unico, com `vpc_id` configuravel.
- Regras de entrada e saida declaradas explicitamente via variaveis, sem liberacao irrestrita por padrao (nenhuma regra de entrada e criada automaticamente; a saida padrao libera apenas HTTPS/443).
- Tags customizaveis combinadas com uma tag `Name` padrao.
- Outputs com identificadores relevantes do recurso criado.

## Uso

```hcl
module "security_group" {
  source = "./"

  name   = "app-sg"
  vpc_id = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description      = "Permite HTTPS de entrada a partir da rede interna."
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/16"]
      ipv6_cidr_blocks = []
    }
  ]

  tags = {
    Environment = "test"
    Project      = "tcc"
  }
}
```

## Requisitos

| Nome | Versao |
|---|---|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS onde os recursos serao provisionados | `string` | `"us-east-1"` | nao |
| name | Nome do Security Group | `string` | - | sim |
| description | Descricao do Security Group | `string` | `"Security Group gerenciado via Terraform."` | nao |
| vpc_id | ID da VPC onde o Security Group sera criado | `string` | - | sim |
| ingress_rules | Lista de regras explicitas de entrada | `list(object)` | `[]` | nao |
| egress_rules | Lista de regras explicitas de saida | `list(object)` | regra HTTPS/443 | nao |
| tags | Tags adicionais aplicadas ao recurso | `map(string)` | `{}` | nao |

## Outputs

| Nome | Descricao |
|---|---|
| security_group_id | ID do Security Group criado |
| security_group_arn | ARN do Security Group criado |
| security_group_name | Nome do Security Group criado |
| security_group_vpc_id | ID da VPC associada ao Security Group |

## Validacao

```bash
terraform fmt
terraform init -backend=false
terraform validate
```
