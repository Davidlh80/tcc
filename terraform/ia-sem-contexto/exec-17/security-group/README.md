# Security Group (AWS)

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, informada via variavel.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0
- Uma VPC ja existente (o `vpc_id` deve ser informado pelo consumidor do modulo)

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "web-sg"
  description = "Security Group para servidores web"

  ingress_rules = [
    {
      description = "Permite HTTPS de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "team-infra"
  }
}
```

## Seguranca por padrao

- `ingress_rules` tem default vazio (`[]`): nenhuma porta e aberta a menos que seja explicitamente configurada.
- `egress_rules` possui um valor padrao permissivo (todo trafego de saida), podendo ser restringido conforme a necessidade do consumidor.
- Todos os `cidr_blocks` informados sao validados como blocos CIDR sintaticamente validos.
- Recomenda-se evitar `0.0.0.0/0` em regras de ingress sempre que possivel, restringindo as origens ao minimo necessario.

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|------|-----------|------|---------|-------------|
| vpc_id | ID da VPC onde o Security Group sera criado | `string` | - | sim |
| aws_region | Regiao AWS utilizada pelo provider | `string` | `"us-east-1"` | nao |
| name | Nome do Security Group | `string` | `"app-security-group"` | nao |
| description | Descricao do Security Group | `string` | `"Security Group gerenciado via Terraform."` | nao |
| ingress_rules | Lista de regras de entrada | `list(object)` | `[]` | nao |
| egress_rules | Lista de regras de saida | `list(object)` | regra permitindo todo trafego de saida | nao |
| tags | Tags adicionais | `map(string)` | `{}` | nao |

## Outputs

| Nome | Descricao |
|------|-----------|
| security_group_id | ID do Security Group criado |
| security_group_arn | ARN do Security Group criado |
| security_group_name | Nome do Security Group criado |
| vpc_id | ID da VPC associada ao Security Group |

## Validacao

Este modulo pode ser validado sem credenciais reais e sem backend remoto:

```bash
terraform init -backend=false
terraform validate
```
