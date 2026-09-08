variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "A região deve estar no formato valido, por exemplo: us-east-1, eu-west-1."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado (não usar a VPC default, a menos que seja intencional)."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC valido, por exemplo: vpc-0123456789abcdef0."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-example"

  validation {
    condition     = length(trim(var.name)) > 0 && length(var.name) <= 255
    error_message = "O nome do Security Group deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Cada item define uma regra."
  type = list(object({
    description       = optional(string)
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = optional(list(string))
    ipv6_cidr_blocks  = optional(list(string))
    prefix_list_ids   = optional(list(string))
    self              = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Protocolo invalido em ingress_rules. Utilize tcp, udp, icmp, icmpv6 ou -1."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        r.to_port >= r.from_port &&
        r.from_port >= -1 &&
        r.to_port >= -1
      )
    ])
    error_message = "Cada regra de ingress deve ter portas validas: from_port <= to_port e ambas >= -1."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        length(coalesce(r.cidr_blocks, [])) +
        length(coalesce(r.ipv6_cidr_blocks, [])) +
        length(coalesce(r.prefix_list_ids, [])) +
        (coalesce(r.self, false) ? 1 : 0)
      ) > 0
    ])
    error_message = "Cada regra de ingress deve definir ao menos uma origem: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou self=true."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress). Cada item define uma regra."
  type = list(object({
    description       = optional(string)
    protocol          = string
    from_port         = number
    to_port           = number
    cidr_blocks       = optional(list(string))
    ipv6_cidr_blocks  = optional(list(string))
    prefix_list_ids   = optional(list(string))
    self              = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["tcp", "udp", "icmp", "icmpv6", "-1"], lower(r.protocol))
    ])
    error_message = "Protocolo invalido em egress_rules. Utilize tcp, udp, icmp, icmpv6 ou -1."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        r.to_port >= r.from_port &&
        r.from_port >= -1 &&
        r.to_port >= -1
      )
    ])
    error_message = "Cada regra de egress deve ter portas validas: from_port <= to_port e ambas >= -1."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        length(coalesce(r.cidr_blocks, [])) +
        length(coalesce(r.ipv6_cidr_blocks, [])) +
        length(coalesce(r.prefix_list_ids, [])) +
        (coalesce(r.self, false) ? 1 : 0)
      ) > 0
    ])
    error_message = "Cada regra de egress deve definir ao menos um destino: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou self=true."
  }
}
