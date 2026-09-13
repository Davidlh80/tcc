# dev-tcc-sg-\<finalidade\>

## Visão geral

Este template Terraform cria um Security Group na AWS, com o ID da VPC configurável por variável. As regras de entrada (ingress) e de saída (egress) são totalmente configuráveis por variável, sem liberação irrestrita por padrão: nenhuma regra é criada a menos que seja explicitamente declarada.

Toda regra de entrada e de saída exige uma descrição não vazia. O uso de `0.0.0.0/0` é proibido em qualquer porta que não seja a 443/tcp, tanto em ingress quanto em egress, validado automaticamente na definição das variáveis.

O nome do Security Group e as tags seguem o padrão organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>` e o conjunto de tags obrigatórias (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`).

## Variáveis

| Nome                   | Tipo                  | Obrigatória | Descrição                                                                                  |
|------------------------|-----------------------|-------------|---------------------------------------------------------------------------------------------|
| `environment`          | `string`              | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                             |
| `system`               | `string`              | Sim         | Nome curto do sistema, usado na nomenclatura padrão.                                         |
| `region`               | `string`              | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                        |
| `additional_tags`      | `map(string)`         | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.                             |
| `security_group_name`  | `string`              | Sim         | Finalidade do Security Group, usada como sufixo do nome padrão.                              |
| `vpc_id`               | `string`              | Sim         | ID da VPC onde o Security Group será criado.                                                 |
| `description`          | `string`              | Não         | Descrição do Security Group. Padrão: `"Security Group gerenciado via Terraform."`.            |
| `ingress_rules`        | `list(object({...}))` | Não         | Lista de regras de entrada (`description`, `protocol`, `from_port`, `to_port`, `cidr_ipv4`). Padrão: `[]`. |
| `egress_rules`         | `list(object({...}))` | Não         | Lista de regras de saída (`description`, `protocol`, `from_port`, `to_port`, `cidr_ipv4`). Padrão: `[]`.   |

## Outputs

| Nome                   | Descrição                                |
|------------------------|--------------------------------------------|
| `security_group_name`  | Nome do Security Group criado.             |
| `security_group_arn`   | ARN do Security Group criado.              |
| `security_group_id`    | ID do Security Group criado.               |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Acesso HTTPS público"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "0.0.0.0/0"
    },
    {
      description = "Acesso SSH restrito à rede interna"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = "10.0.0.0/16"
    }
  ]

  egress_rules = [
    {
      description = "Saída HTTPS para atualizações e APIs externas"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "0.0.0.0/0"
    }
  ]

  additional_tags = {
    Team = "platform"
  }
}
```
