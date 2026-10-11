# Security Group - Blueprint Terraform

## Descricao

Este modulo provisiona um Security Group na AWS dentro de uma VPC especifica, informada via variavel. Nenhuma regra de entrada ou saida e criada por padrao: todas as regras devem ser declaradas explicitamente pelo consumidor do modulo, evitando aberturas irrestritas (como `0.0.0.0/0` em todas as portas) sem necessidade real.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0
- Uma VPC existente (preferencialmente criada pelo proprio ambiente, nao a VPC default da conta)

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "sg-app-web"
  description = "Security Group para a camada web da aplicacao"

  ingress_rules = [
    {
      description = "HTTPS de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH restrito a rede corporativa"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saida HTTPS para atualizacoes e APIs externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "equipe-plataforma"
  }
}
```

## Variaveis

| Nome            | Descricao                                                                 | Tipo   | Padrao          | Obrigatorio |
|-----------------|-----------------------------------------------------------------------------|--------|-----------------|-------------|
| aws_region      | Regiao AWS utilizada pelo provider                                         | string | "us-east-1"     | nao         |
| vpc_id          | ID da VPC onde o Security Group sera criado                                | string | -               | sim         |
| name            | Nome do Security Group                                                     | string | "sg-app"        | nao         |
| description     | Descricao do Security Group                                                | string | ver variables.tf| nao         |
| ingress_rules   | Lista de regras de entrada explicitas                                      | list(object) | []        | nao         |
| egress_rules    | Lista de regras de saida explicitas                                        | list(object) | []        | nao         |
| tags            | Tags adicionais aplicadas ao recurso                                        | map(string) | {}         | nao         |

Cada item de `ingress_rules` e `egress_rules` aceita os campos: `description`, `from_port`, `to_port`, `protocol`, `cidr_blocks` (opcional) e `security_groups` (opcional, para referenciar outro Security Group como origem/destino).

## Outputs

| Nome                 | Descricao                                   |
|----------------------|----------------------------------------------|
| security_group_id    | ID do Security Group criado                  |
| security_group_arn   | ARN do Security Group criado                  |
| security_group_name  | Nome do Security Group criado                 |
| vpc_id               | ID da VPC associada ao Security Group         |

## Validacao

```
terraform init -backend=false
terraform validate
```

## Boas praticas aplicadas

- Nenhuma regra de entrada/saida e criada por padrao, exigindo declaracao explicita.
- Validacao de formato do `vpc_id` e de consistencia de portas nas regras.
- Uso de `security_groups` como origem/destino, permitindo restringir o trafego a outros Security Groups em vez de CIDRs amplos quando aplicavel.
- Tags consistentes, com `Name` derivado automaticamente da variavel `name` e combinavel com tags adicionais.
