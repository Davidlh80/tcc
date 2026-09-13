variable "environment" {
  description = "Ambiente de implantação do recurso"
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação ao qual o recurso pertence"
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão provisionados"
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias"
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada na composição do nome padronizado (<ambiente>-<sistema>-sg-<finalidade>)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name))
    error_message = "O valor de security_group_name deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC válido (ex.: vpc-0123456789abcdef0)."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Cada regra deve conter descrição, portas, protocolo e blocos CIDR."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      length(trimspace(rule.description)) > 0 &&
      rule.from_port <= rule.to_port &&
      (!contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443))
    ])
    error_message = "Cada regra de entrada deve ter descrição não vazia, from_port <= to_port, e não pode liberar 0.0.0.0/0 em porta diferente de 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. Cada regra deve conter descrição, portas, protocolo e blocos CIDR."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      length(trimspace(rule.description)) > 0 &&
      rule.from_port <= rule.to_port &&
      (!contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443))
    ])
    error_message = "Cada regra de saída deve ter descrição não vazia, from_port <= to_port, e não pode liberar 0.0.0.0/0 em porta diferente de 443/tcp."
  }
}
