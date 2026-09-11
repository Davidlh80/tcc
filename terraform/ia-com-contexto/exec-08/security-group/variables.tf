variable "region" {
  description = "Região AWS onde o Security Group será criado."
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A variável 'region' deve ser uma região AWS válida (ex.: us-east-1, sa-east-1)."
  }
}

variable "environment" {
  description = "Ambiente alvo do recurso (dev, hml, prd)."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculas, números e hífens)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas a todos os recursos suportados."
  type        = map(string)
  default     = {}
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
  default     = null
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC válido (ex.: vpc-abcdef1234567890)."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra deve conter descrição e fontes (CIDR IPv4/IPv6)."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Todas as regras de entrada devem conter 'description' não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      alltrue([
        for c in r.cidr_blocks :
        c != "0.0.0.0/0" || (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
      ])
    ])
    error_message = "Ingress: 0.0.0.0/0 só é permitido para 443/tcp."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      alltrue([
        for c in r.ipv6_cidr_blocks :
        c != "::/0" || (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
      ])
    ])
    error_message = "Ingress: ::/0 só é permitido para 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Deve ser declarada explicitamente (padrão: nenhuma regra)."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Todas as regras de saída devem conter 'description' não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      alltrue([
        for c in r.cidr_blocks :
        c != "0.0.0.0/0" || (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
      ])
    ])
    error_message = "Egress: 0.0.0.0/0 só é permitido para 443/tcp."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      alltrue([
        for c in r.ipv6_cidr_blocks :
        c != "::/0" || (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)
      ])
    ])
    error_message = "Egress: ::/0 só é permitido para 443/tcp."
  }
}
