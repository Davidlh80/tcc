# Security Group (AWS) — Blueprint Terraform

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC configuravel (nao a VPC default da conta). Nenhuma regra de entrada ou saida e criada por padrao: todas as regras de ingress/egress devem ser declaradas explicitamente via variaveis, evitando aberturas irrestritas desnecessarias (ex.: `0.0.0.0/0` em todas as portas).

## Arquivos

- `main.tf` — recurso `aws_security_group`, com blocos dinamicos de ingress/egress.
- `variables.tf` — variaveis de entrada (VPC, nome, descricao, regras, tags).
- `outputs.tf` — outputs com ID, ARN, nome e VPC do Security Group.
- `versions.tf` — versao do Terraform e do provider AWS.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security Group da aplicacao"
  aws_region  = "us-east-1"

  ingress_rules = [
    {
      description = "HTTPS a partir da VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "HTTPS para a internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "test"
    Owner       = "squad-infra"
  }
}
```

## Variaveis principais

| Nome            | Descricao                                             | Default       |
|-----------------|--------------------------------------------------------|---------------|
| `vpc_id`        | ID da VPC onde o Security Group sera criado           | obrigatorio   |
| `name`          | Nome do Security Group                                 | `app-sg`      |
| `description`   | Descricao do Security Group                            | texto padrao  |
| `ingress_rules` | Lista de regras de entrada (porta, protocolo, CIDRs)   | `[]`          |
| `egress_rules`  | Lista de regras de saida (porta, protocolo, CIDRs)     | `[]`          |
| `tags`          | Tags adicionais                                         | `{}`          |
| `aws_region`    | Regiao AWS do provider                                  | `us-east-1`   |

## Outputs

| Nome                   | Descricao                          |
|------------------------|-------------------------------------|
| `security_group_id`    | ID do Security Group criado         |
| `security_group_arn`   | ARN do Security Group criado        |
| `security_group_name`  | Nome do Security Group criado       |
| `vpc_id`                | VPC associada ao Security Group     |

## Validacao

```
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e utilizado e nenhuma credencial real e necessaria para a validacao sintatica.
