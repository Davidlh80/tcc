# Security Group (Terraform)

Blueprint Terraform para provisionamento de um AWS Security Group dentro de uma VPC configuravel, com regras explicitas de entrada e saida.

## Caracteristicas

- VPC configuravel via variavel (`vpc_id`), sem depender da VPC padrao da conta.
- Nenhuma regra de entrada aberta por padrao (`ingress_rules` comeca vazio) — o consumidor deve declarar explicitamente as portas e origens necessarias.
- Regra de saida padrao restrita a HTTPS (porta 443), evitando liberacao irrestrita de todo o trafego de saida.
- Tags customizaveis, com a tag `Name` aplicada automaticamente.
- `create_before_destroy` habilitado para evitar indisponibilidade em recriacoes.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "web-sg"

  ingress_rules = [
    {
      description = "Permite HTTPS da internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite SSH apenas da rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "exemplo"
  }
}
```

## Inputs

| Nome          | Tipo                 | Padrao                           | Descricao                                             |
|---------------|----------------------|-----------------------------------|--------------------------------------------------------|
| vpc_id        | string               | n/a (obrigatorio)                 | ID da VPC onde o Security Group sera criado.          |
| name          | string               | "app-sg"                          | Nome do Security Group.                               |
| description   | string               | "Security group gerenciado via Terraform" | Descricao do Security Group.                 |
| ingress_rules | list(object)         | []                                 | Regras de entrada explicitas.                         |
| egress_rules  | list(object)         | HTTPS (443) para 0.0.0.0/0         | Regras de saida explicitas.                           |
| tags          | map(string)          | {}                                 | Tags adicionais.                                      |

## Outputs

| Nome                 | Descricao                                   |
|----------------------|----------------------------------------------|
| security_group_id    | ID do Security Group criado.                 |
| security_group_arn   | ARN do Security Group criado.                |
| security_group_name  | Nome do Security Group criado.               |
| vpc_id               | ID da VPC associada ao Security Group.       |
| ingress_rules_count  | Quantidade de regras de entrada aplicadas.   |
| egress_rules_count   | Quantidade de regras de saida aplicadas.     |

## Validacao

```bash
terraform init -backend=false
terraform validate
```
