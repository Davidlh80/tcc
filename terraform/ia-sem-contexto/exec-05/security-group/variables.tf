variable "region" {
  description = "Regiao AWS a ser utilizada pelo provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(var.region) > 0
    error_message = "A regiao nao pode ser vazia."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado (ex: vpc-0abc123def4567890)."
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrao de IDs da AWS (ex: vpc-0abc123def4567890)."
  }
}

variable "name" {
  description = "Nome do Security Group (tambem aplicado como tag Name)."
  type        = string
  default     = "sg-managed"
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
  validation {
    condition     = length(var.description) > 0 && length(var.description) <= 255
    error_message = "A descricao deve ter entre 1 e 255 caracteres."
  }
}

variable "tags" {
  description = "Mapa de tags adicionais."
  type        = map(string)
  default     = {}
}

variable "revoke_rules_on_delete" {
  description = "Se verdadeiro, revoga regras associadas antes de remover o SG (recomendado)."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress)."
  type = list(object({
    description      = optional(string, "Managed by Terraform")
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= -1 && r.from_port <= 65535 &&
      r.to_port >= -1 && r.to_port <= 65535 &&
      r.from_port <= r.to_port
    ])
    error_message = "Ingress: from/to_port devem estar entre -1 e 65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "Ingress: protocol deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress)."
  type = list(object({
    description      = optional(string, "Managed by Terraform")
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    security_groups  = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= -1 && r.from_port <= 65535 &&
      r.to_port >= -1 && r.to_port <= 65535 &&
      r.from_port <= r.to_port
    ])
    error_message = "Egress: from/to_port devem estar entre -1 e 65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "Egress: protocol deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }
}
