# Security Group (AWS)

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, informada via variavel `vpc_id`. As regras de entrada e saida sao configuraveis por meio de listas de objetos, permitindo total flexibilidade sem alterar o codigo.

## Seguranca por padrao

- `ingress_rules` tem valor padrao vazio (`[]`): nenhuma porta e aberta a menos que seja explicitamente configurada.
- `egress_rules` tem um padrao permissivo (todo trafego de saida), padrao comum em Security Groups, mas pode ser restringido sobrescrevendo a variavel.
- Nenhum valor sensivel ou credencial e fixado no codigo.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "HTTPS da internet"
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

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.3.0 |
| aws | ~> 5.0 |

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|------|-----------|------|--------|-------------|
| vpc_id | ID da VPC onde o Security Group sera criado | `string` | - | sim |
| region | Regiao AWS utilizada pelo provider | `string` | `"us-east-1"` | nao |
| name | Nome do Security Group | `string` | `"sg-example"` | nao |
| description | Descricao do Security Group | `string` | `"Security Group gerenciado via Terraform"` | nao |
| ingress_rules | Lista de regras de entrada | `list(object)` | `[]` | nao |
| egress_rules | Lista de regras de saida | `list(object)` | permite todo trafego de saida | nao |
| tags | Tags adicionais | `map(string)` | `{}` | nao |

## Outputs

| Nome | Descricao |
|------|-----------|
| security_group_id | ID do Security Group criado |
| security_group_arn | ARN do Security Group criado |
| security_group_name | Nome do Security Group criado |
| vpc_id | ID da VPC associada |
| owner_id | ID da conta AWS proprietaria do Security Group |

## Validacao

```
terraform init -backend=false
terraform validate
```
