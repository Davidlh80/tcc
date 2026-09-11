variable "environment" {
  description = "Ambiente de implantação (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0 && length(var.system) <= 30
    error_message = "system deve conter apenas [a-z0-9-] e ter até 30 caracteres."
  }
}

variable "region" {
  description = "Região AWS para o provider (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group (usado no sufixo do nome)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0 && length(var.security_group_name) <= 30
    error_message = "security_group_name deve conter apenas [a-z0-9-] e ter até 30 caracteres."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform seguindo padrões corporativos."
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0 && can(regex("^vpc-([0-9a-f]+)$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC válido (ex.: vpc-xxxxxxxx)."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra requer descrição. 0.0.0.0/0 é permitido SOMENTE para tcp/443."
  type = list(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : (
        length(trim(r.description)) > 0
        && r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535
        && length(r.cidr_blocks) > 0
        && alltrue([
          for c in r.cidr_blocks :
          c != "0.0.0.0/0" || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        ])
      )
    ])
    error_message = "Cada regra de ingress deve ter descrição, portas válidas, ao menos um CIDR e pode usar 0.0.0.0/0 somente para tcp/443."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Obrigatório declarar explicitamente. 0.0.0.0/0 é permitido SOMENTE para tcp/443."
  type = list(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
  }))

  validation {
    condition = length(var.egress_rules) > 0 && alltrue([
      for r in var.egress_rules : (
        length(trim(r.description)) > 0
        && r.from_port >= 0 && r.to_port >= r.from_port && r.to_port <= 65535
        && length(r.cidr_blocks) > 0
        && alltrue([
          for c in r.cidr_blocks :
          c != "0.0.0.0/0" || (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
        ])
      )
    ])
    error_message = "egress_rules é obrigatório e cada regra deve ter descrição, portas válidas, ao menos um CIDR e pode usar 0.0.0.0/0 somente para tcp/443."
  }
}
