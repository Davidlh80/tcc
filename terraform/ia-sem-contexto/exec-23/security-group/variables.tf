variable "region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o padrão, por exemplo: us-east-1, eu-west-1."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,}$", var.vpc_id))
    error_message = "Forneça um VPC ID válido (ex: vpc-0123abcd4567ef89)."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255 && can(regex("^[A-Za-z0-9._-]+$", var.name))
    error_message = "O nome deve ter até 255 caracteres e conter apenas letras, números, ponto, underscore e hífen."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado pelo Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Por padrão, nenhuma regra é criada (tudo negado)."
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string                # ex: tcp, udp, icmp, icmpv6, -1
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    prefix_list_ids  = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= -1 && r.from_port <= 65535 && r.to_port >= -1 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "As portas das regras de ingress devem estar entre -1 e 65535 e from_port deve ser <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], r.protocol)
    ])
    error_message = "O protocolo das regras de ingress deve ser um de: tcp, udp, icmp, icmpv6 ou -1."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(coalesce(r.cidr_blocks, [])) + length(coalesce(r.ipv6_cidr_blocks, [])) + length(coalesce(r.security_groups, [])) + length(coalesce(r.prefix_list_ids, [])) > 0
    ])
    error_message = "Cada regra de ingress deve ter ao menos uma origem: cidr_blocks, ipv6_cidr_blocks, security_groups ou prefix_list_ids."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress). Se null, usa a regra padrão da AWS (tudo liberado)."
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string                # ex: tcp, udp, icmp, icmpv6, -1
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    prefix_list_ids  = optional(list(string))
  }))
  default = null

  validation {
    condition = var.egress_rules == null ? true : alltrue([
      for r in var.egress_rules :
      r.from_port >= -1 && r.from_port <= 65535 && r.to_port >= -1 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "As portas das regras de egress devem estar entre -1 e 65535 e from_port deve ser <= to_port."
  }

  validation {
    condition = var.egress_rules == null ? true : alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], r.protocol)
    ])
    error_message = "O protocolo das regras de egress deve ser um de: tcp, udp, icmp, icmpv6 ou -1."
  }

  validation {
    condition = var.egress_rules == null ? true : alltrue([
      for r in var.egress_rules :
      length(coalesce(r.cidr_blocks, [])) + length(coalesce(r.ipv6_cidr_blocks, [])) + length(coalesce(r.security_groups, [])) + length(coalesce(r.prefix_list_ids, [])) > 0
    ])
    error_message = "Cada regra de egress deve ter ao menos um destino: cidr_blocks, ipv6_cidr_blocks, security_groups ou prefix_list_ids."
  }
}

variable "revoke_rules_on_delete" {
  description = "Se verdadeiro, revoga regras antes de excluir o Security Group, evitando órfãos."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais para aplicar ao Security Group."
  type        = map(string)
  default     = {}
}
