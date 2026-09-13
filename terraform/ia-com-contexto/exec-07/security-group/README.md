# Security Group

## Visão geral do recurso

Este template Terraform provisiona um Security Group na AWS associado a uma VPC informada por variável (`vpc_id`). O nome do recurso segue o padrão de nomenclatura organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `dev-tcc-sg-web`) e todas as tags obrigatórias da organização são aplicadas automaticamente.

As regras de entrada e de saída são totalmente configuráveis por variável (`ingress_rules` e `egress_rules`), sem valores fixos no código. Por padrão, nenhuma regra é criada, seguindo o princípio do menor privilégio. Toda regra informada deve conter uma descrição obrigatória, e o uso de `0.0.0.0/0` só é permitido quando a regra se restringe à porta 443/tcp; qualquer outra combinação com `0.0.0.0/0` é rejeitada na validação da variável, tanto para entrada quanto para saída.

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
|---|---|---|---|
| environment | string | Sim | Ambiente de implantação (`dev`, `hml` ou `prd`). |
| system | string | Sim | Nome do sistema ou produto, usado na nomenclatura padronizada. |
| region | string | Não | Região AWS onde o recurso será provisionado. Padrão: `us-east-1`. |
| additional_tags | map(string) | Não | Tags adicionais mescladas com as tags obrigatórias da organização. Padrão: `{}`. |
| security_group_name | string | Sim | Finalidade do Security Group, usada como sufixo na nomenclatura padronizada (ex.: `web`, `db`, `api`). |
| security_group_description | string | Não | Descrição do Security Group. Padrão: `"Security Group gerenciado via Terraform."`. |
| vpc_id | string | Sim | ID da VPC onde o Security Group será criado. |
| ingress_rules | list(object) | Não | Lista de regras de entrada, cada uma com `description`, `from_port`, `to_port`, `protocol` e `cidr_blocks`. Padrão: `[]`. |
| egress_rules | list(object) | Não | Lista de regras de saída, cada uma com `description`, `from_port`, `to_port`, `protocol` e `cidr_blocks`. Padrão: `[]`. |

## Outputs

| Nome | Descrição |
|---|---|
| security_group_name | Nome do Security Group criado. |
| security_group_arn | ARN do Security Group criado. |
| security_group_id | ID do Security Group criado. |

## Exemplo de uso

module "sg_web" {
  source = "./security-group"

  environment          = "dev"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Permite acesso HTTPS de clientes internos"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite saída HTTPS para atualizacoes e chamadas de API externas"
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
