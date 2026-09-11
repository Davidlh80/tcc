variable "environment" {
  description = "Ambiente de implantação do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (somente minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o recurso será criado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "region não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao recurso."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC válido (ex.: vpc-xxxxxxxx)."
  }
}

variable "security_group_name" {
  description = "Finalidade/nome lógico do Security Group (usado na nomenclatura)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra deve conter descrição e origem/destino explícitos."
  type = list(object({
    description         = string
    from_port           = number
    to_port             = number
    protocol            = string
    cidr_blocks         = optional(list(string), [])
    ipv6_cidr_blocks    = optional(list(string), [])
    security_group_ids  = optional(list(string), [])
    self                = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : (
        length(trim(r.description)) > 0 &&
        r.from_port <= r.to_port &&
        (
          length(r.cidr_blocks) > 0 ||
          length(r.ipv6_cidr_blocks) > 0 ||
          length(r.security_group_ids) > 0 ||
          r.self
        ) &&
        (
          contains(r.cidr_blocks, "0.0.0.0/0") ?
          (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443) :
          true
        )
      )
    ])
    error_message = "Cada regra de ingress deve: ter description; from_port <= to_port; especificar ao menos uma origem (cidr_blocks, ipv6_cidr_blocks, security_group_ids ou self=true); e não pode usar 0.0.0.0/0 exceto exatamente para tcp:443."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress) explícitas. Obrigatório ao menos uma regra. Sujeito às mesmas restrições de segurança."
  type = list(object({
    description         = string
    from_port           = number
    to_port             = number
    protocol            = string
    cidr_blocks         = optional(list(string), [])
    ipv6_cidr_blocks    = optional(list(string), [])
    security_group_ids  = optional(list(string), [])
    self                = optional(bool, false)
  }))

  validation {
    condition     = length(var.egress_rules) > 0
    error_message = "egress_rules deve conter pelo menos uma regra para garantir egress explícito (não é permitido egress irrestrito por padrão)."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules : (
        length(trim(r.description)) > 0 &&
        r.from_port <= r.to_port &&
        (
          length(r.cidr_blocks) > 0 ||
          length(r.ipv6_cidr_blocks) > 0 ||
          length(r.security_group_ids) > 0 ||
          r.self
        ) &&
        (
          contains(r.cidr_blocks, "0.0.0.0/0") ?
          (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443) :
          true
        )
      )
    ])
    error_message = "Cada regra de egress deve: ter description; from_port <= to_port; especificar ao menos um destino (cidr_blocks, ipv6_cidr_blocks, security_group_ids ou self=true); e não pode usar 0.0.0.0/0 exceto exatamente para tcp:443."
  }
}
