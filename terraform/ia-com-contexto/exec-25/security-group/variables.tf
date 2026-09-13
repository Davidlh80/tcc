variable "environment" {
  description = "Ambiente de implantação do recurso. Deve ser um dos ambientes permitidos pela organização."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "A variável 'environment' deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação ao qual o recurso pertence, utilizado na composição do nome padronizado."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "A variável 'system' não pode ser vazia."
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

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "A variável 'vpc_id' deve corresponder a um ID de VPC válido, iniciando com 'vpc-'."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada na composição do nome padronizado (ex.: 'web')."
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "A variável 'security_group_name' não pode ser vazia."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Toda regra deve conter descrição obrigatória. O CIDR 0.0.0.0/0 só é permitido em regras restritas à porta 443/tcp."
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
    error_message = "Toda regra de entrada deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : alltrue([
        for cidr in rule.cidr_blocks :
        cidr != "0.0.0.0/0" || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
      ])
    ])
    error_message = "O CIDR 0.0.0.0/0 só é permitido em regras de entrada restritas exclusivamente à porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. Toda regra deve conter descrição obrigatória. Não há liberação irrestrita por padrão; o egress deve ser declarado explicitamente. O CIDR 0.0.0.0/0 só é permitido em regras restritas à porta 443/tcp."
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
    error_message = "Toda regra de saída deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules : alltrue([
        for cidr in rule.cidr_blocks :
        cidr != "0.0.0.0/0" || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
      ])
    ])
    error_message = "O CIDR 0.0.0.0/0 só é permitido em regras de saída restritas exclusivamente à porta 443/tcp."
  }
}
