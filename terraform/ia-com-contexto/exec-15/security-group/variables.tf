variable "region" {
  description = "Região AWS para o provisionamento."
  type        = string

  validation {
    condition     = can(regex("[a-z]{2}-[a-z]+-\\d", var.region))
    error_message = "A região deve estar no formato válido (ex.: us-east-1, sa-east-1)."
  }
}

variable "environment" {
  description = "Ambiente de implantação. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "Environment inválido. Utilize um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculo, alfanumérico e hífen)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas aos recursos (as tags obrigatórias são sempre aplicadas e prevalecem)."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve estar no formato 'vpc-xxxxxxxx'."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group (comporá o nome no padrão <env>-<sistema>-sg-<finalidade>). Ex.: web, db, app."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group. Se não informada, uma descrição padrão será aplicada."
  type        = string
  default     = null

  validation {
    condition     = var.security_group_description == null || length(trim(var.security_group_description)) > 0
    error_message = "Se informado, security_group_description não pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Cada regra deve possuir descrição e exatamente um tipo de origem."
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string), [])
    ipv6_cidr_blocks         = optional(list(string), [])
    prefix_list_ids          = optional(list(string), [])
    source_security_group_id = optional(string)
    self                     = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : length(trim(r.description)) > 0
    ])
    error_message = "Toda regra de ingress deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules : (
        (
          (length(r.cidr_blocks) > 0 ? 1 : 0) +
          (length(r.ipv6_cidr_blocks) > 0 ? 1 : 0) +
          (length(r.prefix_list_ids) > 0 ? 1 : 0) +
          (try(r.self, false) ? 1 : 0) +
          (try(r.source_security_group_id, null) != null ? 1 : 0)
        ) == 1
      )
    ])
    error_message = "Cada regra de ingress deve especificar exatamente UMA origem entre: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, self ou source_security_group_id."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        (contains(try(r.cidr_blocks, []), "0.0.0.0/0") || contains(try(r.ipv6_cidr_blocks, []), "::/0"))
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      )
    ])
    error_message = "Ingress: é proibido 0.0.0.0/0 ou ::/0 em qualquer porta além de tcp/443."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress). Egress deve ser explícito; não há liberação irrestrita por padrão."
  type = list(object({
    description                     = string
    from_port                       = number
    to_port                         = number
    protocol                        = string
    cidr_blocks                     = optional(list(string), [])
    ipv6_cidr_blocks                = optional(list(string), [])
    prefix_list_ids                 = optional(list(string), [])
    destination_security_group_id   = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.egress_rules : length(trim(r.description)) > 0
    ])
    error_message = "Toda regra de egress deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules : (
        (
          (length(r.cidr_blocks) > 0 ? 1 : 0) +
          (length(r.ipv6_cidr_blocks) > 0 ? 1 : 0) +
          (length(r.prefix_list_ids) > 0 ? 1 : 0) +
          (try(r.destination_security_group_id, null) != null ? 1 : 0)
        ) == 1
      )
    ])
    error_message = "Cada regra de egress deve especificar exatamente UM destino entre: cidr_blocks, ipv6_cidr_blocks, prefix_list_ids ou destination_security_group_id."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        (contains(try(r.cidr_blocks, []), "0.0.0.0/0") || contains(try(r.ipv6_cidr_blocks, []), "::/0"))
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      )
    ])
    error_message = "Egress: é proibido 0.0.0.0/0 ou ::/0 em qualquer porta além de tcp/443."
  }
}
