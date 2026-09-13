variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao proprietaria do recurso."
  type        = string
  default     = "tcc"

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
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
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, no formato vpc-xxxxxxxx."
  }
}

variable "security_group_name" {
  description = "Nome do Security Group, seguindo o padrao <ambiente>-<sistema>-sg-<finalidade>, ex.: hml-tcc-sg-web."
  type        = string

  validation {
    condition     = can(regex("^(dev|hml|prd)-[a-z0-9]+-sg-[a-z0-9-]+$", var.security_group_name))
    error_message = "O valor de security_group_name deve seguir o padrao <ambiente>-<sistema>-sg-<finalidade>, ex.: hml-tcc-sg-web."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Toda regra deve conter descricao. O CIDR 0.0.0.0/0 somente e permitido na porta 443/tcp."
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
    error_message = "Toda regra de ingress_rules deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 em ingress_rules somente e permitido para a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group. Toda regra deve conter descricao. O CIDR 0.0.0.0/0 somente e permitido na porta 443/tcp. Nao ha liberacao irrestrita por padrao."
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
    error_message = "Toda regra de egress_rules deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 em egress_rules somente e permitido para a porta 443/tcp."
  }
}
