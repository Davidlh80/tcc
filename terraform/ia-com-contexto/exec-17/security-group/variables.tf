variable "environment" {
  type        = string
  description = "Ambiente de implantação do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicação ao qual o Security Group pertence."

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde os recursos serão provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais mescladas às tags obrigatórias da organização."
  default     = {}
}

variable "security_group_name" {
  type        = string
  description = "Finalidade do Security Group, usada para compor o nome padronizado <ambiente>-<sistema>-sg-<finalidade>."

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name não pode ser vazio."
  }
}

variable "security_group_description" {
  type        = string
  description = "Descrição do Security Group."
  default     = "Managed by Terraform."
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
  description = "Regras de entrada do Security Group. Cada regra exige descrição obrigatória. 0.0.0.0/0 só é permitido na porta 443/tcp."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de ingress deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "0.0.0.0/0 só é permitido para a porta 443/tcp em regras de ingress."
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
  description = "Regras de saída do Security Group. Não há liberação irrestrita por padrão (default vazio); cada regra deve ser declarada explicitamente com descrição obrigatória. 0.0.0.0/0 só é permitido na porta 443/tcp."
  default     = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de egress deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "0.0.0.0/0 só é permitido para a porta 443/tcp em regras de egress."
  }
}
