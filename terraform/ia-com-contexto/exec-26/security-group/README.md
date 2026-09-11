Visão geral do recurso
Este template cria um Security Group na AWS seguindo o padrão de nomenclatura <ambiente>-<sistema>-sg-<finalidade>, aplica as tags corporativas obrigatórias e permite configurar regras de entrada e saída por variáveis. Atende às diretrizes de segurança exigindo descrição em todas as regras, proibindo 0.0.0.0/0 em qualquer porta além de 443/tcp e exigindo egress explícito (sem liberação irrestrita por padrão).

Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome                      | Tipo                                                                 | Obrigatória | Descrição                                                                                                  |
|---------------------------|----------------------------------------------------------------------|-------------|--------------------------------------------------------------------------------------------------------------|
| environment               | string                                                               | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd.                                                     |
| system                    | string                                                               | Sim         | Nome do sistema/aplicação (minúsculas, números e hífens).                                                   |
| region                    | string                                                               | Sim         | Região AWS (ex.: us-east-1).                                                                                |
| additional_tags           | map(string)                                                          | Não         | Tags adicionais a serem mescladas às tags padrão.                                                           |
| vpc_id                    | string                                                               | Sim         | ID da VPC onde o Security Group será criado.                                                                |
| security_group_name       | string                                                               | Sim         | Finalidade do Security Group (compõe o sufixo do nome).                                                     |
| security_group_description| string                                                               | Sim         | Descrição do Security Group.                                                                                |
| ingress_rules             | list(object)                                                         | Não         | Regras de entrada. Cada item: { description, protocol, from_port, to_port, cidr_blocks?, ipv6_cidr_blocks?, source_security_group_ids? }. 0.0.0.0/0 somente permitido para tcp/443. |
| egress_rules              | list(object)                                                         | Sim         | Regras de saída explícitas. Cada item: { description, protocol, from_port, to_port, cidr_blocks?, ipv6_cidr_blocks?, destination_security_group_ids? }. 0.0.0.0/0 somente permitido para tcp/443. |

Tabela de outputs (nome, descrição)
| Nome                 | Descrição                          |
|----------------------|------------------------------------|
| security_group_id    | ID do Security Group criado.       |
| security_group_arn   | ARN do Security Group criado.      |
| security_group_name  | Nome do Security Group criado.     |

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./"

  environment                = "dev"
  system                     = "tcc"
  region                     = "us-east-1"
  vpc_id                     = "vpc-0123abcd4567efgh"
  security_group_name        = "web"
  security_group_description = "Security Group para workload web HTTPS-only"

  additional_tags = {
    Application = "web-app"
  }

  ingress_rules = [
    {
      description               = "Permitir HTTPS público"
      protocol                  = "tcp"
      from_port                 = 443
      to_port                   = 443
      cidr_blocks               = ["0.0.0.0/0"]
      ipv6_cidr_blocks          = []
      source_security_group_ids = []
    },
    # Exemplo: permitir tráfego interno da app
    {
      description               = "Permitir tráfego interno da app tier"
      protocol                  = "tcp"
      from_port                 = 8443
      to_port                   = 8443
      cidr_blocks               = ["10.0.0.0/16"]
      ipv6_cidr_blocks          = []
      source_security_group_ids = []
    }
  ]

  egress_rules = [
    {
      description                    = "Saída HTTPS para Internet"
      protocol                       = "tcp"
      from_port                      = 443
      to_port                        = 443
      cidr_blocks                    = ["0.0.0.0/0"]
      ipv6_cidr_blocks               = []
      destination_security_group_ids = []
    }
  ]
}
