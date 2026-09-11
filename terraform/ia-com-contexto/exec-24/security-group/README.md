Visão geral do recurso
- Blueprint Terraform para criação de um Security Group na AWS conforme política interna de IaC.
- Nomenclatura padronizada: <environment>-<system>-sg-<security_group_name>.
- Tags obrigatórias aplicadas automaticamente.
- Controles de segurança:
  - Proíbe 0.0.0.0/0 (e ::/0) em qualquer porta além da 443/tcp.
  - Descrição obrigatória em todas as regras de entrada e saída.
  - Egress explícito: por padrão, nenhum tráfego de saída é permitido (sem liberação irrestrita).
- Totalmente configurável por variáveis e compatível com terraform fmt, init (-backend=false) e validate.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment
  - Tipo: string
  - Obrigatória: sim
  - Descrição: Ambiente alvo. Valores permitidos: dev, hml, prd.
- system
  - Tipo: string
  - Obrigatória: sim
  - Descrição: Identificador do sistema (ex.: tcc). Use letras minúsculas, números e hífens.
- region
  - Tipo: string
  - Obrigatória: sim
  - Descrição: Região AWS (ex.: us-east-1).
- additional_tags
  - Tipo: map(string)
  - Obrigatória: não
  - Descrição: Tags adicionais. Não pode sobrescrever Project, Environment, ManagedBy, Owner, CostCenter.
- security_group_name
  - Tipo: string
  - Obrigatória: sim
  - Descrição: Finalidade do Security Group usada na nomenclatura (ex.: web, db).
- security_group_description
  - Tipo: string
  - Obrigatória: não
  - Descrição: Descrição do Security Group.
- vpc_id
  - Tipo: string
  - Obrigatória: sim
  - Descrição: ID da VPC onde o Security Group será criado.
- ingress_rules
  - Tipo: list(object)
  - Obrigatória: não
  - Descrição: Regras de entrada. Cada regra deve ter description, protocolo, portas e pelo menos um de cidr_blocks ou ipv6_cidr_blocks. 0.0.0.0/0 (ou ::/0) só é permitido para 443/tcp.
- egress_rules
  - Tipo: list(object)
  - Obrigatória: não
  - Descrição: Regras de saída explícitas. Por padrão, nenhuma regra é criada (nenhum tráfego de saída permitido). 0.0.0.0/0 (ou ::/0) só é permitido para 443/tcp.

Tabela de outputs (nome, descrição)
- security_group_name: Nome do Security Group criado.
- security_group_arn: ARN do Security Group criado.
- security_group_id: ID do Security Group criado.

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./"

  environment          = "dev"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"
  security_group_description = "SG para workload web com regras restritivas"

  additional_tags = {
    Application = "webapp"
  }

  ingress_rules = [
    {
      description       = "HTTPS público"
      protocol          = "tcp"
      from_port         = 443
      to_port           = 443
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
    },
    {
      description       = "SSH restrito da rede corporativa"
      protocol          = "tcp"
      from_port         = 22
      to_port           = 22
      cidr_blocks       = ["10.0.0.0/8"]
      ipv6_cidr_blocks  = []
    }
  ]

  # Sem egress_rules => nenhum tráfego de saída permitido por padrão.
  # Exemplo de egress controlado (opcional):
  # egress_rules = [
  #   {
  #     description       = "Saída HTTPS"
  #     protocol          = "tcp"
  #     from_port         = 443
  #     to_port           = 443
  #     cidr_blocks       = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks  = []
  #   }
  # ]
}
