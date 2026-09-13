variable "environment" {
  description = "Ambiente de implantação do recurso (dev, hml ou prd)"
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação ao qual o recurso pertence"
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
  description = "Tags adicionais a serem mescladas com as tags obrigatórias definidas pela organização"
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
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de vpc_id não pode ser vazio."
  }
}

variable "description" {
  description = "Descrição do Security Group"
  type        = string
  default     = "Security Group gerenciado via Terraform"

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "O valor de description não pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. 0.0.0.0/0 é permitido somente em regras restritas à porta 443/tcp"
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
    error_message = "Toda regra de ingress deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : (
        !contains(rule.cidr_blocks, "0.0.0.0/0") ||
        (rule.from_port == 443 && rule.to_port == 443 && lower(rule.protocol) == "tcp")
      )
    ])
    error_message = "0.0.0.0/0 só é permitido em regras de ingress restritas à porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. 0.0.0.0/0 é permitido somente em regras restritas à porta 443/tcp"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite tráfego HTTPS de saída"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de egress deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : (
        !contains(rule.cidr_blocks, "0.0.0.0/0") ||
        (rule.from_port == 443 && rule.to_port == 443 && lower(rule.protocol) == "tcp")
      )
    ])
    error_message = "0.0.0.0/0 só é permitido em regras de egress restritas à porta 443/tcp."
  }
}
