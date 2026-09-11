1. Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão organizacional. O nome do recurso é formado por: <environment>-<system>-sg-<security_group_name>. As tags obrigatórias são aplicadas automaticamente e é possível definir tags adicionais. Regras de entrada e saída são configuráveis por variáveis, exigem descrição e respeitam a política: é proibido 0.0.0.0/0 em qualquer porta além de 443/tcp. O egress é explicitamente declarado e não é liberado por padrão.

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome                      | Tipo                                                | Obrigatória | Descrição                                                                                       |
|--------------------------|-----------------------------------------------------|-------------|-------------------------------------------------------------------------------------------------|
| region                   | string                                              | Sim         | Região AWS para provisionamento.                                                                |
| environment              | string                                              | Sim         | Ambiente (dev, hml, prd).                                                                       |
| system                   | string                                              | Sim         | Identificador do sistema (minúsculas, números e hífens).                                        |
| security_group_name      | string                                              | Sim         | Nome/finalidade do Security Group (minúsculas, números e hífens).                               |
| security_group_description | string                                            | Não         | Descrição do Security Group. Padrão informativo.                                                |
| vpc_id                   | string                                              | Sim         | ID da VPC onde o Security Group será criado.                                                    |
| ingress_rules            | list(object)                                        | Não         | Regras de entrada. Campos: description, protocol, from_port, to_port, cidr_blocks (lista CIDRs).|
| egress_rules             | list(object)                                        | Não         | Regras de saída. Campos: description, protocol, from_port, to_port, cidr_blocks (lista CIDRs).  |
| additional_tags          | map(string)                                         | Não         | Tags adicionais a serem mescladas com as tags obrigatórias.                                     |

3. Tabela de outputs (nome, descrição)
| Nome                 | Descrição                          |
|----------------------|------------------------------------|
| security_group_name  | Nome do Security Group criado.     |
| security_group_arn   | ARN do Security Group criado.      |
| security_group_id    | ID do Security Group criado.       |

4. Exemplo de uso do módulo/recurso
module "sg_example" {
  source = "."

  region              = "us-east-1"
  environment         = "dev"
  system              = "tcc"
  vpc_id              = "vpc-0123456789abcdef0"
  security_group_name = "web"

  # Regras de entrada: HTTPs público e acesso interno
  ingress_rules = [
    {
      description = "HTTPS público"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Acesso interno app"
      protocol    = "tcp"
      from_port   = 8080
      to_port     = 8080
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]

  # Regras de saída: apenas HTTPS para internet e DNS para resolvers internos
  egress_rules = [
    {
      description = "Saída HTTPS para internet"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "DNS para resolvers internos"
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      cidr_blocks = ["10.0.0.2/32", "10.0.0.3/32"]
    }
  ]

  additional_tags = {
    Tribe = "platform"
  }
}
