variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou produto ao qual o recurso pertence."
  type        = string
  default     = "tcc"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde o Security Group sera criado."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada na composicao do nome padronizado (ex.: web)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name))
    error_message = "O valor de security_group_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Cada regra deve conter descricao obrigatoria."
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
      length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de ingress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 so e permitido em regras de ingress para a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group. Cada regra deve conter descricao obrigatoria."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS de saida"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de egress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 so e permitido em regras de egress para a porta 443/tcp."
  }
}
