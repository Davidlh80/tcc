variable "region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve estar no formato válido, por exemplo: us-east-1, sa-east-1."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id deve ter o formato vpc-xxxxxxxx ou vpc-xxxxxxxxxxxxxxxxx (hex)."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform."
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress)."
  type = list(object({
    description              = optional(string)
    protocol                 = string
    from_port                = number
    to_port                  = number
    cidr_blocks              = optional(list(string), [])
    ipv6_cidr_blocks         = optional(list(string), [])
    prefix_list_ids          = optional(list(string), [])
    peer_security_group_ids  = optional(list(string), [])
    self                     = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : (
        (r.from_port == -1 && r.to_port == -1) ||
        (r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535)
      )
    ])
    error_message = "Ingress: from_port/to_port devem ser -1 ambos, ou 0-65535 com to_port >= from_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + length(r.peer_security_group_ids) + (r.self ? 1 : 0) > 0
    ])
    error_message = "Ingress: cada regra deve especificar pelo menos um destino de origem (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, peer_security_group_ids ou self=true)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress). Por padrão vazio (nenhuma saída permitida)."
  type = list(object({
    description              = optional(string)
    protocol                 = string
    from_port                = number
    to_port                  = number
    cidr_blocks              = optional(list(string), [])
    ipv6_cidr_blocks         = optional(list(string), [])
    prefix_list_ids          = optional(list(string), [])
    peer_security_group_ids  = optional(list(string), [])
    # campo 'self' não é utilizado em egress
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules : (
        (r.from_port == -1 && r.to_port == -1) ||
        (r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535)
      )
    ])
    error_message = "Egress: from_port/to_port devem ser -1 ambos, ou 0-65535 com to_port >= from_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.prefix_list_ids) + length(r.peer_security_group_ids) > 0
    ])
    error_message = "Egress: cada regra deve especificar pelo menos um destino (cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou peer_security_group_ids)."
  }
}
