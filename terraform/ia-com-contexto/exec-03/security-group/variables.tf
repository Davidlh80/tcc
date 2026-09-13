variable "environment" {
  description = "Ambiente de implantação do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação ao qual o recurso pertence."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada na composição do nome padrão (ex.: 'web', 'db')."
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name não pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
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
  description = "Lista de regras de entrada do Security Group. O CIDR '0.0.0.0/0' só é permitido quando from_port e to_port forem 443 e protocol for 'tcp'. Vazia por padrão (sem liberação implícita)."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_ipv4   = string
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
      rule.cidr_ipv4 != "0.0.0.0/0" || (rule.from_port == 443 && rule.to_port == 443 && lower(rule.protocol) == "tcp")
    ])
    error_message = "O CIDR 0.0.0.0/0 só é permitido em regras restritas à porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. O CIDR '0.0.0.0/0' só é permitido quando from_port e to_port forem 443 e protocol for 'tcp'. Vazia por padrão (sem liberação irrestrita implícita)."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_ipv4   = string
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
      rule.cidr_ipv4 != "0.0.0.0/0" || (rule.from_port == 443 && rule.to_port == 443 && lower(rule.protocol) == "tcp")
    ])
    error_message = "O CIDR 0.0.0.0/0 só é permitido em regras restritas à porta 443/tcp."
  }
}
