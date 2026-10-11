# Security Group — Blueprint Terraform

Blueprint para provisionamento de um Security Group na AWS dentro de uma VPC existente (fornecida via variavel), com regras explicitas de entrada e saida, tags configuraveis e outputs relevantes.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS (`hashicorp/aws`) ~> 5.0

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "app-security-group"

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
      description = "Permite HTTPS de saida"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "test"
  }
}
```

## Variaveis principais

| Nome            | Descricao                                             | Tipo   | Default                     |
| --------------- | ------------------------------------------------------ | ------ | ---------------------------- |
| `aws_region`    | Regiao AWS utilizada pelo provider                     | string | `"us-east-1"`                |
| `vpc_id`        | ID da VPC onde o Security Group sera criado             | string | (obrigatorio)                |
| `name`          | Nome do Security Group                                  | string | `"app-security-group"`       |
| `description`   | Descricao do Security Group                             | string | `"Security group gerenciado via Terraform"` |
| `ingress_rules` | Lista de regras de entrada explicitas                   | list(object) | regra HTTPS interna     |
| `egress_rules`  | Lista de regras de saida explicitas                      | list(object) | HTTPS + DNS              |
| `tags`          | Tags adicionais aplicadas ao recurso                     | map(string) | `{}`                    |

## Outputs

| Nome                      | Descricao                                 |
| ------------------------- | ------------------------------------------ |
| `security_group_id`       | ID do Security Group criado                |
| `security_group_arn`      | ARN do Security Group criado               |
| `security_group_name`     | Nome do Security Group criado              |
| `security_group_vpc_id`   | ID da VPC associada                        |
| `security_group_owner_id` | ID da conta AWS proprietaria do recurso    |

## Observacoes de seguranca

- Nenhuma regra de entrada ou saida e aberta por padrao para `0.0.0.0/0` sem necessidade: a regra de ingress padrao restringe o CIDR a uma faixa interna de VPC (`10.0.0.0/16`), devendo ser ajustada conforme o CIDR real da VPC utilizada no teste.
- As regras de egress padrao liberam apenas HTTPS e DNS, evitando liberacao irrestrita de saida.
- Todas as regras sao validadas (protocolo e faixa de portas) antes da aplicacao.
