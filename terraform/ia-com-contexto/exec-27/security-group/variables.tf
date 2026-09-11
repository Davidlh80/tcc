variable "environment" {
  description = "Ambiente do recurso (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores permitidos: dev, hml ou prd."
  }
}

variable "system" {
  description = "Sistema ao qual o recurso pertence. Use letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  description = "Região AWS (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve estar no formato válido (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso."
  type        = map(string)
  default     = {}

  validation {
    condition = length(setintersection(
      keys(var.additional_tags),
      ["Project", "Environment", "ManagedBy", "Owner", "CostCenter"]
    )) == 0
    error_message = "additional_tags não pode sobrescrever as tags obrigatórias: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group a compor o nome (padrão <environment>-<system>-sg-<security_group_name>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name))
    error_message = "security_group_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC válido (ex.: vpc-0123456789abcdef0)."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Descrição é obrigatória em cada regra. 0.0.0.0/0 é permitido somente para tcp/443."
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
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Cada regra em ingress_rules deve possuir uma descrição não vazia."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : r.from_port <= r.to_port])
    error_message = "Em ingress_rules, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(r.cidr_blocks, "0.0.0.0/0")
      ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "Em ingress_rules, quando utilizar 0.0.0.0/0, somente tcp/443 é permitido."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Descrição é obrigatória em cada regra. 0.0.0.0/0 é permitido somente para tcp/443. Egress é explícito e vazio por padrão."
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
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Cada regra em egress_rules deve possuir uma descrição não vazia."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : r.from_port <= r.to_port])
    error_message = "Em egress_rules, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(r.cidr_blocks, "0.0.0.0/0")
      ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "Em egress_rules, quando utilizar 0.0.0.0/0, somente tcp/443 é permitido."
  }
}
