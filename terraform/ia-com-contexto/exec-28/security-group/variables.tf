variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence, utilizado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera criado."
  type        = string

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada para compor o nome padronizado <ambiente>-<sistema>-sg-<finalidade>."
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name nao pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security group gerenciado via Terraform."

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "O valor de description nao pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Cada regra deve conter descricao obrigatoria e nao pode liberar 0.0.0.0/0 fora da porta 443/tcp."
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
    error_message = "Toda regra de ingress_rules deve conter uma descricao (description) nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "0.0.0.0/0 so e permitido em regras cuja porta seja exatamente 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group. Cada regra deve conter descricao obrigatoria e nao pode liberar 0.0.0.0/0 fora da porta 443/tcp. Nao ha liberacao irrestrita por padrao (lista vazia por default)."
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
    error_message = "Toda regra de egress_rules deve conter uma descricao (description) nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "0.0.0.0/0 so e permitido em regras cuja porta seja exatamente 443/tcp."
  }
}
