variable "environment" {
  description = "Ambiente do recurso (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(trim(var.system)) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o recurso será provisionado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "region não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos. Tags obrigatórias serão preservadas."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group (utilizado na nomenclatura)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(trim(var.security_group_name)) > 0
    error_message = "security_group_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"

  validation {
    condition     = length(trim(var.security_group_description)) > 0
    error_message = "security_group_description não pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = length(trim(var.vpc_id)) > 0
    error_message = "vpc_id não pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Pelo menos um destino deve ser informado por regra. 0.0.0.0/0 (ou ::/0) somente permitido para 443/tcp."
  type = list(object({
    description                    = string
    from_port                      = number
    to_port                        = number
    protocol                       = string                      # tcp, udp, icmp, icmpv6, -1
    ipv4_cidrs                     = optional(list(string), [])
    ipv6_cidrs                     = optional(list(string), [])
    prefix_list_ids                = optional(list(string), [])
    referenced_security_group_ids  = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : length(trim(r.description)) > 0
    ])
    error_message = "Todas as regras de entrada devem conter 'description' não vazio."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Nas regras de entrada, 'protocol' deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        length(r.ipv4_cidrs) + length(r.ipv6_cidrs) + length(r.prefix_list_ids) + length(r.referenced_security_group_ids)
      ) > 0
    ])
    error_message = "Cada regra de entrada deve especificar ao menos um destino: ipv4_cidrs, ipv6_cidrs, prefix_list_ids ou referenced_security_group_ids."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        length([for c in r.ipv4_cidrs : c if c == "0.0.0.0/0"]) == 0 &&
        length([for c in r.ipv6_cidrs : c if c == "::/0"]) == 0
      )
      ||
      (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "Regras de entrada com 0.0.0.0/0 ou ::/0 são permitidas somente para 443/tcp (from_port=443 e to_port=443)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Pelo menos um destino deve ser informado por regra. 0.0.0.0/0 (ou ::/0) somente permitido para 443/tcp. Por padrão, nenhuma saída é permitida."
  type = list(object({
    description                    = string
    from_port                      = number
    to_port                        = number
    protocol                       = string                      # tcp, udp, icmp, icmpv6, -1
    ipv4_cidrs                     = optional(list(string), [])
    ipv6_cidrs                     = optional(list(string), [])
    prefix_list_ids                = optional(list(string), [])
    referenced_security_group_ids  = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules : length(trim(r.description)) > 0
    ])
    error_message = "Todas as regras de saída devem conter 'description' não vazio."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Nas regras de saída, 'protocol' deve ser um de: tcp, udp, icmp, icmpv6, -1."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        length(r.ipv4_cidrs) + length(r.ipv6_cidrs) + length(r.prefix_list_ids) + length(r.referenced_security_group_ids)
      ) > 0
    ])
    error_message = "Cada regra de saída deve especificar ao menos um destino: ipv4_cidrs, ipv6_cidrs, prefix_list_ids ou referenced_security_group_ids."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        length([for c in r.ipv4_cidrs : c if c == "0.0.0.0/0"]) == 0 &&
        length([for c in r.ipv6_cidrs : c if c == "::/0"]) == 0
      )
      ||
      (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "Regras de saída com 0.0.0.0/0 ou ::/0 são permitidas somente para 443/tcp (from_port=443 e to_port=443)."
  }
}
