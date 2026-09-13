variable "environment" {
  description = "Ambiente de implantação do recurso (dev, hml ou prd)"
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
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
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização"
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group, usada para compor o nome padronizado (ex.: web, database)"
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name não pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC válido, iniciado com 'vpc-'."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Cada regra exige descrição, e 0.0.0.0/0 só é permitido para a porta 443/tcp"
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
      (!contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp"))
    ])
    error_message = "Cada regra de entrada deve ter descrição não vazia, e 0.0.0.0/0 só é permitido para a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. Cada regra exige descrição, e 0.0.0.0/0 só é permitido para a porta 443/tcp. Não há liberação irrestrita por padrão"
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
      (!contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp"))
    ])
    error_message = "Cada regra de saída deve ter descrição não vazia, e 0.0.0.0/0 só é permitido para a porta 443/tcp."
  }
}
