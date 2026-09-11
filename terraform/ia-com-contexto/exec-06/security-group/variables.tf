variable "environment" {
  description = "Ambiente do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "system deve corresponder ao padrão ^[a-z0-9]+(-[a-z0-9]+)*$ (minúsculas, números e hífens, sem hífen no início/fim)."
  }
}

variable "region" {
  description = "Região AWS (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve corresponder ao padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a aplicar em conjunto com as tags obrigatórias."
  type        = map(string)
  default     = {}

  validation {
    condition = length([
      for k in keys(var.additional_tags) :
      k if contains(["Project", "Environment", "ManagedBy", "Owner", "CostCenter"], k)
    ]) == 0
    error_message = "additional_tags não pode sobrescrever as tags obrigatórias: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrão ^vpc-[0-9a-f]+$."
  }
}

variable "security_group_name" {
  description = "Nome do Security Group seguindo o padrão <environment>-<system>-sg-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^${var.environment}-${var.system}-sg-[a-z0-9-]+$", var.security_group_name))
    error_message = "security_group_name deve seguir o padrão <environment>-<system>-sg-<finalidade> (minúsculas, números e hífens)."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string

  validation {
    condition     = length(trim(var.security_group_description)) > 0 && length(var.security_group_description) <= 255
    error_message = "security_group_description é obrigatório e deve ter até 255 caracteres."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra deve conter descrição e ser explicitamente definida."
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = []

  validation {
    condition     = length([for r in var.ingress_rules : 1 if length(trim(r.description)) == 0]) == 0
    error_message = "Toda regra de entrada deve conter uma descrição não vazia."
  }

  validation {
    condition = length([
      for r in var.ingress_rules : 1
      if (length(r.cidr_blocks) == 0 && length(r.ipv6_cidr_blocks) == 0)
    ]) == 0
    error_message = "Cada regra de entrada deve definir ao menos um destino (cidr_blocks ou ipv6_cidr_blocks)."
  }

  validation {
    condition = length([
      for r in var.ingress_rules : 1
      if (
        (contains(r.cidr_blocks, "0.0.0.0/0") || contains(r.ipv6_cidr_blocks, "::/0"))
        &&
        !(lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ]) == 0
    error_message = "É proibido usar 0.0.0.0/0 ou ::/0 em portas diferentes de 443/tcp nas regras de entrada."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída explícitas. Obrigatório definir ao menos uma regra (não há liberação irrestrita por padrão)."
  type = list(object({
    description      = string
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))

  validation {
    condition     = length(var.egress_rules) > 0
    error_message = "Deve haver pelo menos uma regra de saída explícita (egress) para evitar liberação irrestrita por padrão."
  }

  validation {
    condition     = length([for r in var.egress_rules : 1 if length(trim(r.description)) == 0]) == 0
    error_message = "Toda regra de saída deve conter uma descrição não vazia."
  }

  validation {
    condition = length([
      for r in var.egress_rules : 1
      if (length(r.cidr_blocks) == 0 && length(r.ipv6_cidr_blocks) == 0)
    ]) == 0
    error_message = "Cada regra de saída deve definir ao menos um destino (cidr_blocks ou ipv6_cidr_blocks)."
  }

  validation {
    condition = length([
      for r in var.egress_rules : 1
      if (
        (contains(r.cidr_blocks, "0.0.0.0/0") || contains(r.ipv6_cidr_blocks, "::/0"))
        &&
        !(lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ]) == 0
    error_message = "É proibido usar 0.0.0.0/0 ou ::/0 em portas diferentes de 443/tcp nas regras de saída."
  }
}
