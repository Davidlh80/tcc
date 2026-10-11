# Security Group (AWS) - Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS, associado a uma VPC configuravel (nao a VPC padrao da conta), com regras explicitas de entrada e saida.

## Caracteristicas

- `vpc_id` e obrigatorio e validado no formato `vpc-xxxxxxxx`, garantindo que o recurso seja criado dentro de uma VPC especifica (por exemplo, uma VPC provisionada pelo proprio ambiente de teste).
- Nenhuma regra de ingress e aplicada por padrao (`ingress_rules = []`), evitando exposicao desnecessaria.
- Regras de ingress nao podem usar `0.0.0.0/0` como origem, forcando a declaracao de CIDRs especificos.
- Por padrao, apenas trafego de saida HTTPS (porta 443) e permitido; demais portas/protocolos de egress podem ser adicionados via variavel.
- Tags customizaveis, com a tag `Name` sempre aplicada automaticamente.
- `lifecycle { create_before_destroy = true }` para evitar indisponibilidade em atualizacoes de regras.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "sg-app"
  description = "Security group para a aplicacao"

  ingress_rules = [
    {
      description = "Permite HTTPS interno"
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
    Environment = "dev"
    Owner        = "time-plataforma"
  }
}
```

## Inputs

| Nome          | Descricao                                                        | Tipo             | Padrao                               |
|---------------|-------------------------------------------------------------------|------------------|----------------------------------------|
| aws_region    | Regiao AWS do provider                                            | string           | `"us-east-1"`                          |
| vpc_id        | ID da VPC onde o Security Group sera criado                       | string           | obrigatorio                            |
| name          | Nome do Security Group                                            | string           | `"sg-managed"`                         |
| description   | Descricao do Security Group                                       | string           | `"Security group gerenciado via Terraform"` |
| ingress_rules | Lista de regras de entrada (description, from_port, to_port, protocol, cidr_blocks) | list(object) | `[]` |
| egress_rules  | Lista de regras de saida (mesma estrutura de ingress_rules)       | list(object)     | HTTPS (443) para `0.0.0.0/0`           |
| tags          | Tags adicionais aplicadas ao recurso                               | map(string)      | `{}`                                   |

## Outputs

| Nome                 | Descricao                                |
|----------------------|--------------------------------------------|
| security_group_id    | ID do Security Group criado                |
| security_group_arn   | ARN do Security Group criado               |
| security_group_name  | Nome do Security Group criado               |
| vpc_id               | ID da VPC associada ao Security Group       |

## Validacao

```bash
terraform init -backend=false
terraform validate
```
