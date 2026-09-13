variable "environment" {
  description = "Ambiente de implantação do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
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
  description = "Finalidade do Security Group, utilizada para compor o nome padronizado (ex.: web, db, app)."
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
  description = "Lista de regras de entrada do Security Group. Cada regra deve conter descrição obrigatória. 0.0.0.0/0 é permitido apenas na porta 443/tcp."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Permite trafego HTTPS de entrada a partir de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de ingress deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
    ])
    error_message = "0.0.0.0/0 só é permitido em regras de ingress na porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group. Cada regra deve conter descrição obrigatória. 0.0.0.0/0 é permitido apenas na porta 443/tcp. Deve haver ao menos uma regra explícita."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Permite trafego HTTPS de saida para qualquer destino"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition     = length(var.egress_rules) > 0
    error_message = "É obrigatório declarar explicitamente ao menos uma regra de egress; liberação irrestrita não é permitida por padrão."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de egress deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
    ])
    error_message = "0.0.0.0/0 só é permitido em regras de egress na porta 443/tcp."
  }
}
