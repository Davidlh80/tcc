variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "A regiao nao pode ser vazia."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "Informe um VPC ID valido no formato vpc-xxxxxxxx."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "app-sg"

  validation {
    condition     = length(trim(var.name)) > 0 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"

  validation {
    condition     = length(trim(var.description)) > 0
    error_message = "A descricao nao pode ser vazia."
  }
}

variable "tags" {
  description = "Tags adicionais para aplicar ao Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Vazia por padrao (deny-all)."
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.from_port <= 65535 && r.to_port >= 0 && r.to_port <= 65535
    ])
    error_message = "As portas (from_port e to_port) em ingress_rules devem estar entre 0 e 65535."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Cada regra de ingress deve especificar ao menos uma origem: cidr_blocks, ipv6_cidr_blocks, security_groups ou self=true."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao permite todo trafego IPv4 de saida."
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = [
    {
      description       = "Allow all outbound IPv4"
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      security_groups   = []
      self              = false
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.from_port <= 65535 && r.to_port >= 0 && r.to_port <= 65535
    ])
    error_message = "As portas (from_port e to_port) em egress_rules devem estar entre 0 e 65535."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks) + length(r.security_groups) + (r.self ? 1 : 0)) > 0
    ])
    error_message = "Cada regra de egress deve especificar ao menos um destino: cidr_blocks, ipv6_cidr_blocks, security_groups ou self=true."
  }
}
