variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)"
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao associado ao recurso"
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera criado"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de uma regiao AWS valida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao"
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada para compor o nome padronizado (ex.: web, database, api)"
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name nao pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descricao do Security Group"
  type        = string
  default     = "Security group gerenciado via Terraform"

  validation {
    condition     = length(trimspace(var.security_group_description)) > 0
    error_message = "O valor de security_group_description nao pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado"
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "O valor de vpc_id deve iniciar com 'vpc-'."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group"
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
      for rule in var.ingress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de entrada deve conter uma descricao."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
    ])
    error_message = "O CIDR 0.0.0.0/0 somente e permitido em regras de entrada para a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group"
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
      for rule in var.egress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de saida deve conter uma descricao."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
    ])
    error_message = "O CIDR 0.0.0.0/0 somente e permitido em regras de saida para a porta 443/tcp."
  }
}
