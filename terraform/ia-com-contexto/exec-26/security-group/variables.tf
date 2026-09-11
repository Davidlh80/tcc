variable "environment" {
  description = "Ambiente do recurso (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação. Use apenas minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para criação dos recursos (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve estar no formato válido (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais para aplicar aos recursos."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao formato de IDs de VPC (ex.: vpc-abc123ef)."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group (parte final do nome)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string

  validation {
    condition     = length(trim(var.security_group_description)) > 0
    error_message = "security_group_description não pode ser vazio."
  }
}

variable "_ingress_rule_object" {
  description = "Tipo interno para validação das regras de ingress (não defina este valor)."
  type = object({
    description                = string
    protocol                   = string
    from_port                  = number
    to_port                    = number
    cidr_blocks                = optional(list(string), [])
    ipv6_cidr_blocks           = optional(list(string), [])
    source_security_group_ids  = optional(list(string), [])
  })
  nullable = false
  default  = {
    description               = "INTERNAL-TYPE"
    protocol                  = "tcp"
    from_port                 = 0
    to_port                   = 0
    cidr_blocks               = []
    ipv6_cidr_blocks          = []
    source_security_group_ids = []
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra deve conter descrição. 0.0.0.0/0 só é permitido em tcp/443."
  type = list(object({
    description               = string
    protocol                  = string
    from_port                 = number
    to_port                   = number
    cidr_blocks               = optional(list(string), [])
    ipv6_cidr_blocks          = optional(list(string), [])
    source_security_group_ids = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(trim(r.description)) > 0
    ])
    error_message = "Toda regra de entrada deve possuir uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "Portas em ingress_rules devem estar no intervalo 0-65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      !(contains(r.cidr_blocks, "0.0.0.0/0") && !(lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443))
    ])
    error_message = "Ingress: 0.0.0.0/0 é permitido somente para tcp/443."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída explícitas (obrigatório). Cada regra deve conter descrição. 0.0.0.0/0 só é permitido em tcp/443."
  type = list(object({
    description                      = string
    protocol                         = string
    from_port                        = number
    to_port                          = number
    cidr_blocks                      = optional(list(string), [])
    ipv6_cidr_blocks                 = optional(list(string), [])
    destination_security_group_ids   = optional(list(string), [])
  }))

  validation {
    condition     = length(var.egress_rules) > 0
    error_message = "É obrigatório declarar ao menos uma regra de egress para evitar liberação irrestrita por padrão."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length(trim(r.description)) > 0
    ])
    error_message = "Toda regra de saída deve possuir uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "Portas em egress_rules devem estar no intervalo 0-65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      !(contains(r.cidr_blocks, "0.0.0.0/0") && !(lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443))
    ])
    error_message = "Egress: 0.0.0.0/0 é permitido somente para tcp/443."
  }
}
