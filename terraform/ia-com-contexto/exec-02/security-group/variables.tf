variable "region" {
  description = "Região AWS onde os recursos serão criados (ex.: us-east-1)."
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "A região deve estar no formato válido (ex.: us-east-1)."
  }
}

variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculas, números e hífens)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas minúsculas, números e hífens."
  }
}

variable "additional_tags" {
  description = "Tags adicionais (não substituem as tags obrigatórias)."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group (usado no nome, ex.: web, db, app)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas minúsculas, números e hífens."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve iniciar com 'vpc-'."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado pelo Terraform"
  validation {
    condition     = length(trim(var.security_group_description)) > 0
    error_message = "A descrição do Security Group não pode ser vazia."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Cada regra deve ter descrição. '0.0.0.0/0' ou '::/0' só é permitido para 443/tcp."
  type = list(object({
    description        = string
    protocol           = string
    from_port          = number
    to_port            = number
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    security_groups    = optional(list(string), [])
    self               = optional(bool, false)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Toda regra de entrada deve conter 'description' não vazia."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : r.from_port <= r.to_port])
    error_message = "Em cada regra de entrada, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = length([
      for r in var.ingress_rules : r
      if (
        (contains(try(r.cidr_blocks, []), "0.0.0.0/0") || contains(try(r.ipv6_cidr_blocks, []), "::/0")) &&
        !(lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ]) == 0
    error_message = "Regras de entrada com 0.0.0.0/0 ou ::/0 só são permitidas para a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress). Cada regra deve ter descrição. '0.0.0.0/0' ou '::/0' só é permitido para 443/tcp. Se vazio, nenhuma saída será permitida."
  type = list(object({
    description        = string
    protocol           = string
    from_port          = number
    to_port            = number
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    security_groups    = optional(list(string), [])
    self               = optional(bool, false)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Toda regra de saída deve conter 'description' não vazia."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : r.from_port <= r.to_port])
    error_message = "Em cada regra de saída, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = length([
      for r in var.egress_rules : r
      if (
        (contains(try(r.cidr_blocks, []), "0.0.0.0/0") || contains(try(r.ipv6_cidr_blocks, []), "::/0")) &&
        !(lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ]) == 0
    error_message = "Regras de saída com 0.0.0.0/0 ou ::/0 só são permitidas para a porta 443/tcp."
  }
}
