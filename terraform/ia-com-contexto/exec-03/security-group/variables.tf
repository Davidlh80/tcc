variable "environment" {
  description = "Ambiente alvo do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provisionamento (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve corresponder ao padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso (sobrescrevem chaves duplicadas)."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrão de IDs de VPC (ex.: vpc-abc123...)."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group (usado na composição do nome conforme padrão <env>-<system>-sg-<finalidade>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada item: { description, from_port, to_port, protocol, cidr_blocks, ipv6_cidr_blocks }."
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : length(trim(r.description)) > 0
    ])
    error_message = "Toda regra de entrada deve possuir uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules : r.from_port <= r.to_port
    ])
    error_message = "Em todas as regras de entrada, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Protocolo inválido em ingress_rules. Permitidos: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules : (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks)) > 0
    ])
    error_message = "Cada regra de entrada deve informar pelo menos um bloco CIDR IPv4 ou IPv6."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(r.cidr_blocks, "0.0.0.0/0") ?
      (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "É proibido usar 0.0.0.0/0 em portas diferentes de 443/tcp nas regras de entrada."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(r.ipv6_cidr_blocks, "::/0") ?
      (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "É proibido usar ::/0 em portas diferentes de 443/tcp nas regras de entrada."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Cada item: { description, from_port, to_port, protocol, cidr_blocks, ipv6_cidr_blocks }."
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules : length(trim(r.description)) > 0
    ])
    error_message = "Toda regra de saída deve possuir uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules : r.from_port <= r.to_port
    ])
    error_message = "Em todas as regras de saída, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules : contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Protocolo inválido em egress_rules. Permitidos: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules : (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks)) > 0
    ])
    error_message = "Cada regra de saída deve informar pelo menos um bloco CIDR IPv4 ou IPv6."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(r.cidr_blocks, "0.0.0.0/0") ?
      (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "É proibido usar 0.0.0.0/0 em portas diferentes de 443/tcp nas regras de saída."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(r.ipv6_cidr_blocks, "::/0") ?
      (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "É proibido usar ::/0 em portas diferentes de 443/tcp nas regras de saída."
  }
}
