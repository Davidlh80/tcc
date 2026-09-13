variable "environment" {
  type        = string
  description = "Ambiente de implantação do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de 'environment' deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Identificador do sistema ou aplicação ao qual o recurso pertence."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de 'system' não pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde os recursos serão provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização."
  default     = {}
}

variable "security_group_name" {
  type        = string
  description = "Finalidade do Security Group, utilizada para compor o nome padronizado (ex.: web, database, bastion)."

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de 'security_group_name' não pode ser vazio."
  }
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Security Group será criado."

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "O valor de 'vpc_id' não pode ser vazio."
  }
}

variable "description" {
  type        = string
  description = "Descrição do Security Group."
  default     = "Security group gerenciado via Terraform."

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "O valor de 'description' não pode ser vazio."
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
  description = "Lista de regras de entrada do Security Group. Cada regra deve conter descrição obrigatória."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de entrada deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && lower(rule.protocol) == "tcp")
    ])
    error_message = "O CIDR 0.0.0.0/0 só é permitido em regras que liberem exclusivamente a porta 443/tcp."
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
  description = "Lista de regras de saída do Security Group. Nenhuma liberação irrestrita é aplicada por padrão."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de saída deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && lower(rule.protocol) == "tcp")
    ])
    error_message = "O CIDR 0.0.0.0/0 só é permitido em regras que liberem exclusivamente a porta 443/tcp."
  }
}
