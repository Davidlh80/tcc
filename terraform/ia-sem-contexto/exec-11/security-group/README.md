# Security Group — Blueprint Terraform

Blueprint Terraform para provisionamento de um Security Group na AWS, com regras explícitas de entrada e saída, VPC configurável e tags customizáveis.

## Recursos criados

- `aws_security_group.this`: Security Group com regras de ingress e egress definidas dinamicamente a partir de variáveis.

## Pré-requisitos

- Terraform `>= 1.5.0`
- Provider AWS `~> 5.0`
- Uma VPC previamente existente (criada pelo ambiente de teste), cujo ID deve ser informado via `var.vpc_id`.

## Uso

```hcl
module "security_group" {
  source = "./"

  region = "us-east-1"
  vpc_id = "vpc-0123456789abcdef0"
  name   = "sg-app-exemplo"

  ingress_rules = [
    {
      description = "Permite HTTPS da rede interna"
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
    Ambiente = "teste"
    Projeto  = "tcc"
  }
}
```

## Boas práticas aplicadas

- Nenhuma regra de **entrada** permite o CIDR irrestrito `0.0.0.0/0` (validado via `validation` na variável `ingress_rules`).
- Regras de entrada e saída são explícitas, por porta e protocolo, evitando liberação ampla desnecessária (ex.: `-1`/todas as portas).
- O ID da VPC é configurável por variável e validado por formato (`vpc-xxxxxxxx`), permitindo uso em qualquer VPC do ambiente de teste.
- Tags obrigatórias (`Name`) e customizáveis (`var.tags`) são aplicadas ao recurso.
- `lifecycle.create_before_destroy` evita indisponibilidade do Security Group durante substituições.

## Inputs

| Nome            | Descrição                                               | Tipo           | Default                  |
| --------------- | -------------------------------------------------------- | -------------- | ------------------------- |
| `region`         | Região AWS onde os recursos serão provisionados          | `string`       | `"us-east-1"`             |
| `vpc_id`         | ID da VPC onde o Security Group será criado              | `string`       | — (obrigatório)           |
| `name`           | Nome do Security Group                                    | `string`       | `"sg-app-exemplo"`        |
| `description`    | Descrição do Security Group                               | `string`       | ver `variables.tf`        |
| `ingress_rules`  | Lista de regras de entrada                                 | `list(object)` | ver `variables.tf`        |
| `egress_rules`   | Lista de regras de saída                                   | `list(object)` | ver `variables.tf`        |
| `tags`           | Tags adicionais aplicadas ao recurso                      | `map(string)`  | `{}`                      |

## Outputs

| Nome                      | Descrição                                   |
| ------------------------- | --------------------------------------------- |
| `security_group_id`       | ID do Security Group criado                   |
| `security_group_arn`      | ARN do Security Group criado                  |
| `security_group_name`     | Nome do Security Group criado                 |
| `security_group_vpc_id`   | ID da VPC associada ao Security Group         |
| `security_group_owner_id` | ID da conta AWS proprietária do recurso       |

## Validação

```bash
terraform init -backend=false
terraform validate
terraform fmt -check
```
