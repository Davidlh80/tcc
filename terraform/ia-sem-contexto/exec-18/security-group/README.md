# Security Group - Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS, com regras explicitas de entrada e saida, dentro de uma VPC configurada externamente (nao a VPC default da conta).

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS `~> 5.0`

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|------|-----------|------|---------|-------------|
| aws_region | Regiao AWS para o provider | string | `us-east-1` | nao |
| vpc_id | ID da VPC onde o Security Group sera criado | string | - | sim |
| name | Nome do Security Group | string | `sg-managed-by-terraform` | nao |
| description | Descricao do Security Group | string | `Security group gerenciado via Terraform.` | nao |
| ingress_rules | Lista de regras de entrada (description, from_port, to_port, protocol, cidr_blocks) | list(object) | regra HTTPS/443 a partir de `10.0.0.0/16` | nao |
| egress_rules | Lista de regras de saida (description, from_port, to_port, protocol, cidr_blocks) | list(object) | regra HTTPS/443 de saida | nao |
| tags | Tags adicionais aplicadas ao recurso | map(string) | `{}` | nao |

## Outputs

| Nome | Descricao |
|------|-----------|
| security_group_id | ID do Security Group criado |
| security_group_arn | ARN do Security Group criado |
| security_group_name | Nome do Security Group criado |
| security_group_vpc_id | ID da VPC associada ao Security Group |
| security_group_owner_id | ID da conta AWS proprietaria do Security Group |

## Exemplo de uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "sg-app-exemplo"

  ingress_rules = [
    {
      description = "Permite HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite saida HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Ambiente = "teste"
  }
}
```

## Consideracoes de seguranca

- Nenhuma regra de entrada ou saida e aberta por padrao para `0.0.0.0/0` em portas administrativas (22/3389); uma validacao de variavel bloqueia essa combinacao.
- As regras de entrada e saida devem ser declaradas explicitamente via `ingress_rules` e `egress_rules`, evitando liberacoes amplas nao intencionais.
- O `vpc_id` e validado para garantir que corresponde ao formato de um ID de VPC valido.
- Ajuste os CIDRs e portas padrao de acordo com a necessidade real do ambiente antes de uso em producao.

## Validacao

```
terraform init -backend=false
terraform validate
```
