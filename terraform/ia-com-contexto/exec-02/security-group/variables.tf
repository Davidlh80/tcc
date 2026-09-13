variable "environment" {
  type        = string
  description = "Ambiente de implantação do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicação ao qual o recurso pertence."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde o recurso será provisionado."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatórias do recurso."
  default     = {}
}

variable "security_group_name" {
  type        = string
  description = "Finalidade do Security Group, usada para compor o nome padronizado (ex.: web, db, api)."

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name não pode ser vazio."
  }
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Security Group será criado."

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id não pode ser vazio."
  }
}

variable "ingress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Lista de regras de entrada do Security Group. Toda regra deve conter descrição e não é permitido liberar 0.0.0.0/0 em portas diferentes de 443/tcp."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      length(trimspace(rule.description)) > 0 &&
      (!contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp"))
    ])
    error_message = "Cada regra de ingress deve ter descrição não vazia; 0.0.0.0/0 só é permitido em regra exclusiva para a porta 443/tcp."
  }
}

variable "egress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Lista de regras de saída do Security Group. Deve ser declarada explicitamente; não há liberação irrestrita por padrão. Toda regra deve conter descrição e não é permitido liberar 0.0.0.0/0 em portas diferentes de 443/tcp."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      length(trimspace(rule.description)) > 0 &&
      (!contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp"))
    ])
    error_message = "Cada regra de egress deve ter descrição não vazia; 0.0.0.0/0 só é permitido em regra exclusiva para a porta 443/tcp."
  }
}
