# Visão geral do recurso
Este template provisiona um Security Group na AWS de forma padronizada e segura, seguindo:
- Padrão de nomes: <ambiente>-<sistema>-sg-<finalidade>
- Tags obrigatórias corporativas
- Regras de segurança:
  - Proibido 0.0.0.0/0 para qualquer porta exceto 443/tcp
  - Descrição obrigatória em todas as regras de entrada e saída
  - Egress declarado explicitamente, sem liberação irrestrita por padrão
- Variáveis com validações e uso extensivo de parâmetros configuráveis

# Tabela de variáveis
| Nome                      | Tipo                                                                                                  | Obrigatória | Descrição |
|---------------------------|-------------------------------------------------------------------------------------------------------|-------------|-----------|
| region                    | string                                                                                                | Sim         | Região AWS onde os recursos serão provisionados. |
| environment               | string                                                                                                | Sim         | Ambiente de implantação. Valores permitidos: dev, hml, prd. |
| system                    | string                                                                                                | Sim         | Identificador do sistema/produto (minúsculas, números e hífens). |
| additional_tags           | map(string)                                                                                           | Não         | Tags adicionais a serem aplicadas aos recursos. |
| security_group_name       | string                                                                                                | Sim         | Finalidade do Security Group (compõe o nome no padrão). |
| security_group_description| string                                                                                                | Não         | Descrição do Security Group. Padrão: "Security Group gerenciado por Terraform." |
| vpc_id                    | string                                                                                                | Sim         | ID da VPC onde o Security Group será criado. |
| ingress_rules             | list(object({ description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string) opcional, ipv6_cidr_blocks=list(string) opcional, source_security_group_ids=list(string) opcional })) | Não         | Regras de entrada. Exige descrição, pelo menos uma origem e proíbe 0.0.0.0/0 exceto tcp/443. |
| egress_rules              | list(object({ description=string, protocol=string, from_port=number, to_port=number, cidr_blocks=list(string) opcional, ipv6_cidr_blocks=list(string) opcional, source_security_group_ids=list(string) opcional })) | Não         | Regras de saída explícitas. Exige descrição, pelo menos um destino e proíbe 0.0.0.0/0 exceto tcp/443. |

# Tabela de outputs
| Nome                  | Descrição |
|-----------------------|-----------|
| security_group_name   | Nome do Security Group criado conforme o padrão corporativo. |
| security_group_arn    | ARN do Security Group. |
| security_group_id     | ID do Security Group. |

# Exemplo de uso
module "sg_web" {
  source = "./"

  region              = "sa-east-1"
  environment         = "hml"
  system              = "tcc"
  security_group_name = "web"
  vpc_id              = "vpc-0123456789abcdef0"

  additional_tags = {
    Application = "portal-web"
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
    {
      description               = "Permitir SSH da rede corporativa"
      protocol                  = "tcp"
      from_port                 = 22
      to_port                   = 22
      cidr_blocks               = ["203.0.113.0/24"]
      ipv6_cidr_blocks          = []
      source_security_group_ids = []
    }
  ]

  egress_rules = [
    {
      description               = "Sair para Internet via HTTPS"
      protocol                  = "tcp"
      from_port                 = 443
      to_port                   = 443
      cidr_blocks               = ["0.0.0.0/0"]
      ipv6_cidr_blocks          = []
      source_security_group_ids = []
    }
  ]
}
