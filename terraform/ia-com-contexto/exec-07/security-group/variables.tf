variable "environment" {
  description = "Ambiente de implantação do recurso (dev, hml ou prd), usado na nomenclatura padronizada e nas tags obrigatórias."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou produto ao qual o recurso pertence, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o Security Group será provisionado."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias definidas pela organização."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group, usada como sufixo na nomenclatura padronizada (ex.: web, db, api)."
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group, exibida no recurso criado na AWS."
  type        = string
  default     = "Security Group gerenciado via Terraform."

  validation {
    condition     = length(trimspace(var.security_group_description)) > 0
    error_message = "O valor de security_group_description não pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id não pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Toda regra deve conter descrição. O uso de 0.0.0.0/0 é permitido apenas para a porta 443/tcp."
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
    error_message = "Toda regra de entrada deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "O uso de 0.0.0.0/0 em regras de entrada só é permitido para a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. Toda regra deve conter descrição. Não há liberação irrestrita por padrão e o uso de 0.0.0.0/0 é permitido apenas para a porta 443/tcp."
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
    error_message = "Toda regra de saída deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "O uso de 0.0.0.0/0 em regras de saída só é permitido para a porta 443/tcp."
  }
}
