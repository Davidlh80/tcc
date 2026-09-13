variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicacao ao qual o recurso pertence."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o Security Group sera provisionado."
  default     = "us-east-1"

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "security_group_name" {
  type        = string
  description = "Finalidade do Security Group, usada para compor o nome padronizado (ex.: web)."

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name nao pode ser vazio."
  }
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Security Group sera criado."

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
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
  description = "Lista de regras de entrada do Security Group. Nenhuma regra e criada por padrao."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de entrada deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : alltrue([
        for cidr in rule.cidr_blocks :
        cidr != "0.0.0.0/0" || (rule.from_port == 443 && rule.to_port == 443 && lower(rule.protocol) == "tcp")
      ])
    ])
    error_message = "O CIDR 0.0.0.0/0 so e permitido em regras de entrada restritas a porta 443/tcp."
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
  description = "Lista de regras de saida do Security Group. Nenhuma liberacao irrestrita e aplicada por padrao."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de saida deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : alltrue([
        for cidr in rule.cidr_blocks :
        cidr != "0.0.0.0/0" || (rule.from_port == 443 && rule.to_port == 443 && lower(rule.protocol) == "tcp")
      ])
    ])
    error_message = "O CIDR 0.0.0.0/0 so e permitido em regras de saida restritas a porta 443/tcp."
  }
}
