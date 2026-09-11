variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (ex.: tcc). Use letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "region deve corresponder ao padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso. Não pode sobrescrever as tags obrigatórias."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k in keys(var.additional_tags) :
      !contains(["Project", "Environment", "ManagedBy", "Owner", "CostCenter"], k)
    ])
    error_message = "additional_tags não pode conter as chaves reservadas: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group usada na nomenclatura (ex.: web, db)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform em conformidade com política interna."
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve iniciar com 'vpc-' seguido por hexadecimal."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Pelo menos um dos campos cidr_blocks ou ipv6_cidr_blocks deve ser informado por regra. Descrição é obrigatória em todas as regras."
  type = list(object({
    description        = string
    protocol           = string   # tcp, udp, icmp, icmpv6, -1
    from_port          = number
    to_port            = number
    cidr_blocks        = list(string)
    ipv6_cidr_blocks   = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Todas as regras de ingress devem ter 'description' não vazia."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))])
    error_message = "Protocolo inválido em ingress_rules. Use 'tcp', 'udp', 'icmp', 'icmpv6' ou '-1'."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      lower(r.protocol) == "-1" ? (r.from_port == 0 && r.to_port == 0) : (r.from_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port)
    ])
    error_message = "Portas inválidas em ingress_rules. Para protocolo '-1' use 0-0; caso contrário 0-65535 e from_port <= to_port."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks)) > 0])
    error_message = "Cada regra de ingress deve definir ao menos um destino: cidr_blocks ou ipv6_cidr_blocks."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (contains(r.cidr_blocks, "0.0.0.0/0") || contains(r.ipv6_cidr_blocks, "::/0"))
      ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "Em ingress, 0.0.0.0/0 ou ::/0 só são permitidos para 443/tcp (from_port=443 e to_port=443)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Sem regras, nenhum tráfego de saída será permitido. Pelo menos um dos campos cidr_blocks ou ipv6_cidr_blocks deve ser informado por regra. Descrição é obrigatória em todas as regras."
  type = list(object({
    description        = string
    protocol           = string   # tcp, udp, icmp, icmpv6, -1
    from_port          = number
    to_port            = number
    cidr_blocks        = list(string)
    ipv6_cidr_blocks   = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Todas as regras de egress devem ter 'description' não vazia."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))])
    error_message = "Protocolo inválido em egress_rules. Use 'tcp', 'udp', 'icmp', 'icmpv6' ou '-1'."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      lower(r.protocol) == "-1" ? (r.from_port == 0 && r.to_port == 0) : (r.from_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port)
    ])
    error_message = "Portas inválidas em egress_rules. Para protocolo '-1' use 0-0; caso contrário 0-65535 e from_port <= to_port."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks)) > 0])
    error_message = "Cada regra de egress deve definir ao menos um destino: cidr_blocks ou ipv6_cidr_blocks."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (contains(r.cidr_blocks, "0.0.0.0/0") || contains(r.ipv6_cidr_blocks, "::/0"))
      ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "Em egress, 0.0.0.0/0 ou ::/0 só são permitidos para 443/tcp (from_port=443 e to_port=443)."
  }
}
