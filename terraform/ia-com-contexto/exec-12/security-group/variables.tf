variable "region" {
  description = "Região AWS onde os recursos serão criados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "A variável region deve estar no formato válido (ex.: us-east-1)."
  }
}

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
    condition     = can(regex("^[a-z0-9-]{2,50}$", var.system))
    error_message = "system deve conter 2-50 caracteres válidos: [a-z0-9-]."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-fA-F]{8}|[0-9a-fA-F]{17})$", var.vpc_id))
    error_message = "vpc_id deve estar no formato 'vpc-xxxxxxxx' ou 'vpc-xxxxxxxxxxxxxxxxx'."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group (parte final do nome). Ex.: web, db, bastion."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,50}$", var.security_group_name))
    error_message = "security_group_name deve conter 1-50 caracteres válidos: [a-z0-9-]."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security group gerenciado por Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra deve possuir descrição e ao menos um CIDR (IPv4 ou IPv6). 0.0.0.0/0 ou ::/0 só são permitidos para TCP/443."
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Todas as regras de entrada devem possuir 'description' não vazia."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks)) > 0])
    error_message = "Cada regra de entrada deve especificar ao menos um CIDR IPv4 ou IPv6."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        contains(r.cidr_blocks, "0.0.0.0/0") || contains(r.ipv6_cidr_blocks, "::/0")
      )
      ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "Regras de entrada com 0.0.0.0/0 ou ::/0 só são permitidas para TCP na porta 443."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535])
    error_message = "As portas em ingress_rules devem estar no intervalo 0-65535 e to_port >= from_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Cada regra deve possuir descrição e ao menos um CIDR (IPv4 ou IPv6). 0.0.0.0/0 ou ::/0 só são permitidos para TCP/443. Por padrão, nenhuma regra é criada."
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Todas as regras de saída devem possuir 'description' não vazia."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : (length(r.cidr_blocks) + length(r.ipv6_cidr_blocks)) > 0])
    error_message = "Cada regra de saída deve especificar ao menos um CIDR IPv4 ou IPv6."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        contains(r.cidr_blocks, "0.0.0.0/0") || contains(r.ipv6_cidr_blocks, "::/0")
      )
      ? (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      : true
    ])
    error_message = "Regras de saída com 0.0.0.0/0 ou ::/0 só são permitidas para TCP na porta 443."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535])
    error_message = "As portas em egress_rules devem estar no intervalo 0-65535 e to_port >= from_port."
  }
}
