variable "environment" {
  description = "Ambiente de implantação do recurso. Deve ser um dos ambientes permitidos pela organização."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema ou aplicação ao qual o recurso pertence, usado na nomenclatura padrão."
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
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada como sufixo no padrão de nomenclatura <ambiente>-<sistema>-sg-<finalidade>."
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "O valor de security_group_name não pode ser vazio."
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

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. 0.0.0.0/0 somente é permitido na porta 443/tcp."
  type = list(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
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
      rule.cidr_ipv4 != "0.0.0.0/0" || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "0.0.0.0/0 só é permitido em regras de entrada na porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. Não há liberação irrestrita por padrão; 0.0.0.0/0 somente é permitido na porta 443/tcp."
  type = list(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
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
      rule.cidr_ipv4 != "0.0.0.0/0" || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "0.0.0.0/0 só é permitido em regras de saída na porta 443/tcp."
  }
}
