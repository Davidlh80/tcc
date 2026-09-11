Visão geral do recurso
Este template provisiona um Security Group na AWS seguindo o padrão organizacional de nomenclatura (<environment>-<system>-sg-<security_group_name>) e aplica as tags obrigatórias. Atende aos controles de segurança definidos:
- Proíbe 0.0.0.0/0 (e ::/0) em qualquer porta diferente de 443/tcp, tanto em ingress quanto em egress.
- Exige descrição em toda regra de entrada e saída.
- Declara egress explicitamente, removendo a liberação irrestrita por padrão quando nenhuma regra de saída é fornecida.
- Permite configurar VPC, regras de entrada e saída via variáveis.

Tabela de variáveis
- environment (string) [obrigatória]: Ambiente de deployment. Valores permitidos: dev, hml, prd.
- system (string) [obrigatória]: Identificador do sistema (ex.: tcc). Use letras minúsculas, números e hifens.
- region (string) [obrigatória]: Região AWS (ex.: us-east-1).
- security_group_name (string) [obrigatória]: Finalidade do SG conforme padrão de nomenclatura (ex.: web, app, db).
- vpc_id (string) [obrigatória]: ID da VPC alvo (ex.: vpc-1234abcd).
- security_group_description (string) [opcional]: Descrição do Security Group. Padrão: "Managed by Terraform".
- ingress_rules (list(object)) [opcional]: Regras de entrada. Padrão: [].
  - Campos do objeto: description (string), from_port (number), to_port (number), protocol (string), cidr_blocks (list(string), opcional), ipv6_cidr_blocks (list(string), opcional), security_groups (list(string), opcional), prefix_list_ids (list(string), opcional), self (bool, opcional).
- egress_rules (list(object)) [opcional]: Regras de saída. Padrão: [] (nenhuma saída liberada).
  - Campos do objeto: description (string), from_port (number), to_port (number), protocol (string), cidr_blocks (list(string), opcional), ipv6_cidr_blocks (list(string), opcional), security_groups (list(string), opcional), prefix_list_ids (list(string), opcional), self (bool, opcional).
- additional_tags (map(string)) [opcional]: Tags adicionais a aplicar. Não sobrescrever: Project, Environment, ManagedBy, Owner, CostCenter.

Tabela de outputs
- security_group_name: Nome do Security Group.
- security_group_arn: ARN do Security Group.
- security_group_id: ID do Security Group.

Exemplo de uso do módulo/recurso
module "sg_web" {
  source = "./"

  region               = "us-east-1"
  environment          = "dev"
  system               = "tcc"
  vpc_id               = "vpc-1234abcd"
  security_group_name  = "web"
  security_group_description = "SG para workloads web - HTTPS only"

  # Ingress: HTTPS público permitido; SSH somente via bastion (exemplo fictício)
  ingress_rules = [
    {
      description       = "HTTPS público"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_groups   = []
      prefix_list_ids   = []
      self              = false
    },
    {
      description       = "SSH via bastion"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = []
      ipv6_cidr_blocks  = []
      security_groups   = ["sg-0bastionid12345678"]
      prefix_list_ids   = []
      self              = false
    }
  ]

  # Egress: somente HTTPS outbound
  egress_rules = [
    {
      description       = "Saída HTTPS"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_groups   = []
      prefix_list_ids   = []
      self              = false
    }
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
