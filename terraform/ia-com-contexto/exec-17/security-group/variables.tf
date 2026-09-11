variable "environment" {
  description = "Ambiente alvo (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (minúsculo, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o padrão AWS, por ex.: us-east-1, sa-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais para aplicar a todos os recursos."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve estar no formato válido, ex.: vpc-123abc456def78901."
  }
}

variable "security_group_name" {
  description = "Finalidade/nome lógico do Security Group (parte final do padrão)."
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
  description = "Lista de regras de entrada. Deve conter descrição e respeitar a política de não usar 0.0.0.0/0 ou ::/0 exceto em 443/tcp."
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : length(trim(r.description)) > 0
    ])
    error_message = "Todas as regras de entrada (ingress) devem ter descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        r.from_port >= 0 &&
        r.to_port <= 65535 &&
        r.to_port >= r.from_port
      )
    ])
    error_message = "Ingress: from_port/to_port devem estar entre 0 e 65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "-1"], lower(r.protocol))
    ])
    error_message = "Ingress: protocolo deve ser um de: tcp, udp, icmp, -1."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        (length(try(r.cidr_blocks, [])) > 0) ||
        (length(try(r.ipv6_cidr_blocks, [])) > 0) ||
        (length(try(r.security_groups, [])) > 0)
      )
    ])
    error_message = "Ingress: cada regra deve especificar pelo menos um destino (cidr_blocks, ipv6_cidr_blocks ou security_groups)."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        (
          !contains(try(r.cidr_blocks, []), "0.0.0.0/0") &&
          !contains(try(r.ipv6_cidr_blocks, []), "::/0")
        )
        ||
        (
          lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443
        )
      )
    ])
    error_message = "Ingress: uso de 0.0.0.0/0 ou ::/0 é proibido exceto para tcp 443."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Deve conter descrição e respeitar a política de não usar 0.0.0.0/0 ou ::/0 exceto em 443/tcp. Sem regras por padrão (egress explícito)."
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules : length(trim(r.description)) > 0
    ])
    error_message = "Todas as regras de saída (egress) devem ter descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        r.from_port >= 0 &&
        r.to_port <= 65535 &&
        r.to_port >= r.from_port
      )
    ])
    error_message = "Egress: from_port/to_port devem estar entre 0 e 65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "-1"], lower(r.protocol))
    ])
    error_message = "Egress: protocolo deve ser um de: tcp, udp, icmp, -1."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        (length(try(r.cidr_blocks, [])) > 0) ||
        (length(try(r.ipv6_cidr_blocks, [])) > 0) ||
        (length(try(r.security_groups, [])) > 0)
      )
    ])
    error_message = "Egress: cada regra deve especificar pelo menos um destino (cidr_blocks, ipv6_cidr_blocks ou security_groups)."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        (
          !contains(try(r.cidr_blocks, []), "0.0.0.0/0") &&
          !contains(try(r.ipv6_cidr_blocks, []), "::/0")
        )
        ||
        (
          lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443
        )
      )
    ])
    error_message = "Egress: uso de 0.0.0.0/0 ou ::/0 é proibido exceto para tcp 443."
  }
}
