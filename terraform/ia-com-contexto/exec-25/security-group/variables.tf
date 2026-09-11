variable "environment" {
  description = "Ambiente de deployment. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema (ex.: tcc). Usar letras minúsculas, números e hifens."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system é obrigatório e deve conter apenas [a-z0-9-]."
  }
}

variable "region" {
  description = "Região AWS (ex.: us-east-1)."
  type        = string
}

variable "additional_tags" {
  description = "Tags adicionais a aplicar nos recursos. Não sobrescreva as chaves obrigatórias."
  type        = map(string)
  default     = {}

  validation {
    condition = length([
      for k, _ in var.additional_tags :
      k if contains(["Project", "Environment", "ManagedBy", "Owner", "CostCenter"], k)
    ]) == 0
    error_message = "additional_tags não pode conter as chaves reservadas: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group conforme padrão de nomenclatura (ex.: web, db, app)."
  type        = string

  validation {
    condition     = length(var.security_group_name) > 0 && can(regex("^[a-z0-9-]+$", var.security_group_name))
    error_message = "security_group_name é obrigatório e deve conter apenas [a-z0-9-]."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]{8,}$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao formato de um ID de VPC válido (ex.: vpc-1234abcd)."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Cada regra deve conter descrição obrigatória."
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    prefix_list_ids   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Toda regra de ingress deve possuir 'description' não vazio."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "Portas de ingress devem estar no intervalo 0-65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        contains(try(r.cidr_blocks, []), "0.0.0.0/0")
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      ) &&
      (
        contains(try(r.ipv6_cidr_blocks, []), "::/0")
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      )
    ])
    error_message = "É proibido usar 0.0.0.0/0 (ou ::/0) em portas diferentes de 443/tcp nas regras de ingress."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress). Deve ser declarado explicitamente; por padrão nenhuma saída é liberada."
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    prefix_list_ids   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Toda regra de egress deve possuir 'description' não vazio."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.to_port <= 65535 && r.from_port <= r.to_port
    ])
    error_message = "Portas de egress devem estar no intervalo 0-65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        contains(try(r.cidr_blocks, []), "0.0.0.0/0")
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      ) &&
      (
        contains(try(r.ipv6_cidr_blocks, []), "::/0")
        ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        : true
      )
    ])
    error_message = "É proibido usar 0.0.0.0/0 (ou ::/0) em portas diferentes de 443/tcp nas regras de egress."
  }
}
