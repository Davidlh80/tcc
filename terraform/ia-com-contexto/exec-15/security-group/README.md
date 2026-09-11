Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo os padrões organizacionais:
- Nome no formato <ambiente>-<sistema>-sg-<finalidade>.
- Tags obrigatórias aplicadas a todos os recursos.
- Regras de segurança que proíbem 0.0.0.0/0 (e ::/0) em qualquer porta além de tcp/443.
- Descrição obrigatória em todas as regras de entrada e saída.
- Egress explicitamente definido, sem liberação irrestrita por padrão.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- region (string) [obrigatória]: Região AWS para o provisionamento (ex.: us-east-1).
- environment (string) [obrigatória]: Ambiente da implantação. Valores permitidos: dev, hml, prd.
- system (string) [obrigatória]: Identificador do sistema/produto (minúsculo, alfanumérico e hífen).
- additional_tags (map(string)) [opcional]: Tags adicionais a aplicar. As tags obrigatórias da organização sempre prevalecem.
- vpc_id (string) [obrigatória]: ID da VPC onde o Security Group será criado.
- security_group_name (string) [obrigatória]: Finalidade do Security Group. Comporá o nome no padrão <env>-<sistema>-sg-<finalidade> (ex.: web, db).
- security_group_description (string) [opcional]: Descrição do Security Group. Se não informada, será usada uma descrição padrão.
- ingress_rules (list(object)) [opcional]: Regras de entrada. Cada regra exige:
  - description (string)
  - from_port (number)
  - to_port (number)
  - protocol (string)
  - EXACTAMENTE UM entre: cidr_blocks (list(string)), ipv6_cidr_blocks (list(string)), prefix_list_ids (list(string)), self (bool), source_security_group_id (string)
  - Restrição: Se 0.0.0.0/0 ou ::/0 forem usados, a regra deve ser exatamente tcp/443.
- egress_rules (list(object)) [opcional]: Regras de saída. Cada regra exige:
  - description (string)
  - from_port (number)
  - to_port (number)
  - protocol (string)
  - EXACTAMENTE UM entre: cidr_blocks (list(string)), ipv6_cidr_blocks (list(string)), prefix_list_ids (list(string)), destination_security_group_id (string)
  - Restrição: Se 0.0.0.0/0 ou ::/0 forem usados, a regra deve ser exatamente tcp/443.
Observação: Egress é explícito e, por padrão, não há tráfego de saída liberado até que regras sejam informadas.

Tabela de outputs (nome, descrição)
- security_group_id: ID do Security Group criado.
- security_group_name: Nome do Security Group criado.
- security_group_arn: ARN do Security Group criado.

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./."

  region                = "us-east-1"
  environment           = "dev"
  system                = "tcc"
  vpc_id                = "vpc-0123456789abcdef0"
  security_group_name   = "web"
  security_group_description = "Security Group para workload web com TLS"

  # Regras de entrada: permitir HTTPS de qualquer origem (conforme política)
  ingress_rules = [
    {
      description              = "Permitir HTTPS público"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = []
      prefix_list_ids          = []
      source_security_group_id = null
      self                     = false
    }
  ]

  # Regras de saída: egress explícito, permitir apenas HTTPS para internet
  egress_rules = [
    {
      description                   = "Egress HTTPS para internet"
      from_port                     = 443
      to_port                       = 443
      protocol                      = "tcp"
      cidr_blocks                   = ["0.0.0.0/0"]
      ipv6_cidr_blocks              = []
      prefix_list_ids               = []
      destination_security_group_id = null
    }
  ]

  additional_tags = {
    Squad = "core-platform"
  }
}
