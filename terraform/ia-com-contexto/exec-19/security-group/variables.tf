variable "region" {
  description = "Região AWS para o provisionamento."
  type        = string
  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "A variável 'region' não pode ser vazia."
  }
}

variable "environment" {
  description = "Ambiente do recurso (dev, hml, prd)."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O 'environment' deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculo, números e hífens)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "O 'system' deve conter apenas letras minúsculas, números e hífens (formato kebab-case)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "O 'vpc_id' deve ser um ID de VPC válido (ex.: vpc-xxxxxxxx)."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group (comporá o nome final)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.security_group_name))
    error_message = "O 'security_group_name' deve conter apenas letras minúsculas, números e hífens (kebab-case)."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra deve conter descrição e respeitar a política de não expor 0.0.0.0/0 exceto para tcp/443."
  type = list(object({
    description        = string
    protocol           = string
    from_port          = number
    to_port            = number
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    prefix_list_ids    = optional(list(string), [])
    security_groups    = optional(list(string), [])
    self               = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(trimspace(r.description)) > 0
    ])
    error_message = "Todas as regras de entrada devem conter 'description' não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length([for c in r.cidr_blocks : c if c == "0.0.0.0/0"]) == 0
      || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "Regras de entrada não podem usar 0.0.0.0/0 exceto exatamente para tcp/443."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Deve ser explícita (sem liberação irrestrita) e respeitar a política de 0.0.0.0/0 apenas para tcp/443."
  type = list(object({
    description        = string
    protocol           = string
    from_port          = number
    to_port            = number
    cidr_blocks        = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
    prefix_list_ids    = optional(list(string), [])
    security_groups    = optional(list(string), [])
    self               = optional(bool, false)
  }))
  # Regra segura padrão: egress apenas para HTTPS
  default = [
    {
      description      = "egress-https-only"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length(trimspace(r.description)) > 0
    ])
    error_message = "Todas as regras de saída devem conter 'description' não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length([for c in r.cidr_blocks : c if c == "0.0.0.0/0"]) == 0
      || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
    ])
    error_message = "Regras de saída não podem usar 0.0.0.0/0 exceto exatamente para tcp/443."
  }
}
