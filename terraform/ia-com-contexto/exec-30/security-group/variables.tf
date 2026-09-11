variable "environment" {
  description = "Ambiente alvo: dev, hml ou prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema (minúsculas, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(trimspace(var.system)) > 0
    error_message = "O valor de system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o Security Group será criado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "Informe uma região AWS válida (ex.: us-east-1)."
  }
}

variable "security_group_name" {
  description = "Nome/finalidade do Security Group (comporá <environment>-<system>-sg-<security_group_name>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(trimspace(var.security_group_name)) > 0
    error_message = "security_group_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrão de IDs de VPC (ex.: vpc-1234abcd ou vpc-12345678abcdef12)."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada item deve conter description, protocol, from_port, to_port e ao menos um destino (cidr_blocks, ipv6_cidr_blocks, security_groups, prefix_list_ids ou self=true)."
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
    security_groups   = list(string)
    prefix_list_ids   = list(string)
    self              = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Ingress: protocol deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port <= r.to_port
    ])
    error_message = "Ingress: from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(trimspace(r.description)) > 0
    ])
    error_message = "Ingress: toda regra deve conter description não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + length(r.prefix_list_ids) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Ingress: cada regra deve especificar ao menos um de: cidr_blocks, ipv6_cidr_blocks, security_groups, prefix_list_ids ou self=true."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      alltrue([
        for c in r.cidr_blocks :
        c != "0.0.0.0/0" || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      ])
    ])
    error_message = "Ingress: é proibido 0.0.0.0/0 em qualquer porta além de 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Se vazio, será criado um egress padrão restritivo (self=true) para evitar liberação irrestrita."
  type = list(object({
    description       = string
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
    security_groups   = list(string)
    prefix_list_ids   = list(string)
    self              = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Egress: protocol deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port <= r.to_port
    ])
    error_message = "Egress: from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length(trimspace(r.description)) > 0
    ])
    error_message = "Egress: toda regra deve conter description não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + length(r.prefix_list_ids) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Egress: cada regra deve especificar ao menos um de: cidr_blocks, ipv6_cidr_blocks, security_groups, prefix_list_ids ou self=true."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas a todos os recursos."
  type        = map(string)
  default     = {}
}
