# Security Group

## Visão geral

Este template provisiona um Security Group na AWS, com o ID da VPC configurável por variável. As regras de entrada e saída são totalmente configuráveis por variável, não possuem liberação irrestrita por padrão (listas vazias) e exigem descrição obrigatória em cada regra. O uso do CIDR `0.0.0.0/0` é restrito exclusivamente a regras limitadas à porta 443/tcp, tanto em entrada quanto em saída. O recurso segue o padrão de nomenclatura `<ambiente>-<sistema>-sg-<finalidade>` e aplica o conjunto de tags obrigatórias da organização.

## Variáveis

| Nome                   | Tipo                  | Obrigatória | Descrição                                                                                     |
|------------------------|-----------------------|-------------|------------------------------------------------------------------------------------------------|
| `environment`          | `string`              | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                               |
| `system`               | `string`              | Sim         | Nome do sistema ou aplicação ao qual o recurso pertence.                                       |
| `region`               | `string`              | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                          |
| `additional_tags`      | `map(string)`         | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.                               |
| `security_group_name`  | `string`              | Sim         | Finalidade do Security Group, usada na composição do nome padronizado (ex.: `web`).            |
| `vpc_id`               | `string`              | Sim         | ID da VPC onde o Security Group será criado.                                                   |
| `ingress_rules`        | `list(object({...}))` | Não         | Regras de entrada (description, from_port, to_port, protocol, cidr_blocks). Padrão: `[]`.      |
| `egress_rules`         | `list(object({...}))` | Não         | Regras de saída (description, from_port, to_port, protocol, cidr_blocks). Padrão: `[]`.        |

## Outputs

| Nome                   | Descrição                          |
|------------------------|-------------------------------------|
| `security_group_name`  | Nome do Security Group criado.      |
| `security_group_arn`   | ARN do Security Group criado.       |
| `security_group_id`    | ID do Security Group criado.        |

## Exemplo de uso

    module "sg_web" {
      source = "./security-group"

      environment          = "dev"
      system                = "tcc"
      region                = "us-east-1"
      vpc_id                = "vpc-0123456789abcdef0"
      security_group_name  = "web"

      ingress_rules = [
        {
          description = "Acesso HTTPS público"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]

      egress_rules = [
        {
          description = "Saída HTTPS para atualizações"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]

      additional_tags = {
        Squad = "plataforma"
      }
    }
