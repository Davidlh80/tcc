variable "environment" {
  description = "Ambiente de implantação do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de 'environment' deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/projeto ao qual o recurso pertence, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = trimspace(var.system) != ""
    error_message = "O valor de 'system' não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o recurso será provisionado."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas às tags obrigatórias do recurso."
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Finalidade/nome do Security Group, usado na composição do nome padronizado (<ambiente>-<sistema>-sg-<finalidade>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name))
    error_message = "O valor de 'security_group_name' deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "O valor de 'vpc_id' deve ser um ID de VPC válido (ex.: vpc-0123456789abcdef0)."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Cada regra deve conter descrição obrigatória. O CIDR 0.0.0.0/0 só é permitido para a porta 443/tcp."
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
      for rule in var.ingress_rules : trimspace(rule.description) != ""
    ])
    error_message = "Todas as regras de entrada (ingress_rules) devem conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 só é permitido em regras de entrada para a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. Cada regra deve conter descrição obrigatória. O CIDR 0.0.0.0/0 só é permitido para a porta 443/tcp. Não há liberação irrestrita por padrão."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Saída HTTPS para integrações e atualizações externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : trimspace(rule.description) != ""
    ])
    error_message = "Todas as regras de saída (egress_rules) devem conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.protocol == "tcp" && rule.from_port == 443 && rule.to_port == 443)
    ])
    error_message = "O CIDR 0.0.0.0/0 só é permitido em regras de saída para a porta 443/tcp."
  }
}
