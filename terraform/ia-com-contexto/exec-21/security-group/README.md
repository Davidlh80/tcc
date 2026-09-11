# Visão geral do recurso

Este template provisiona um Security Group na AWS conforme o padrão organizacional:
- Nomenclatura: <ambiente>-<sistema>-sg-<finalidade>
- Tags obrigatórias aplicadas automaticamente
- Regras de segurança:
  - Proíbe 0.0.0.0/0 e ::/0 em qualquer porta, exceto 443/tcp
  - Exige descrição em todas as regras de entrada e saída
  - Egress declarado explicitamente (sem permissão irrestrita por padrão)
- Todas as entradas configuráveis são variáveis com validações básicas

# Tabela de variáveis

| Nome                    | Tipo                                                                                                   | Obrigatória | Descrição |
|-------------------------|--------------------------------------------------------------------------------------------------------|------------:|-----------|
| environment             | string                                                                                                 | Sim         | Ambiente alvo: dev, hml ou prd. |
| system                  | string                                                                                                 | Sim         | Nome do sistema/aplicação (componente '<sistema>' na nomenclatura). |
| region                  | string                                                                                                 | Sim         | Região AWS do provider. |
| security_group_name     | string                                                                                                 | Sim         | Finalidade do SG (componente '<finalidade>' na nomenclatura), ex.: web, app, db. |
| security_group_description | string                                                                                              | Não         | Descrição do Security Group. Padrão: "Security Group gerenciado por Terraform". |
| vpc_id                  | string                                                                                                 | Sim         | ID da VPC onde o SG será criado. |
| additional_tags         | map(string)                                                                                            | Não         | Tags adicionais. As tags obrigatórias sempre serão aplicadas. |
| ingress_rules           | list(object)                                                                                           | Não         | Regras de entrada. Cada item: { description (string), from_port (number), to_port (number), protocol (string), cidr_blocks (list(string)), ipv6_cidr_blocks (list(string)), prefix_list_ids (list(string)), security_groups (list(string)), self (bool) }. 0.0.0.0/0 e ::/0 apenas para 443/tcp. |
| egress_rules            | list(object)                                                                                           | Não         | Regras de saída. Cada item: { description (string), from_port (number), to_port (number), protocol (string), cidr_blocks (list(string)), ipv6_cidr_blocks (list(string)), prefix_list_ids (list(string)), security_groups (list(string)), self (bool) }. Egress explícito. 0.0.0.0/0 e ::/0 apenas para 443/tcp. |

# Tabela de outputs

| Nome                 | Descrição |
|----------------------|-----------|
| security_group_name  | Nome do Security Group criado, seguindo o padrão corporativo. |
| security_group_arn   | ARN do Security Group. |
| security_group_id    | ID do Security Group. |

# Exemplo de uso

module "sg" {
  source = "."

  region               = "us-east-1"
  environment          = "hml"
  system               = "tcc"
  security_group_name  = "web"
  security_group_description = "SG para front-end web"
  vpc_id               = "vpc-0123456789abcdef0"

  additional_tags = {
    Squad = "plataforma"
  }

  ingress_rules = [
    {
      description      = "HTTPS público"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH restrito"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/8"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress_rules = [
    {
      description      = "Saída HTTPS para internet"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Saída para rede interna (TCP 5432)"
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/8"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}
