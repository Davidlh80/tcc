variable "environment" {
  description = "Ambiente alvo. Deve seguir o padrão organizacional."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos valores permitidos: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (componente '<sistema>' na nomenclatura)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "O system deve conter apenas letras minúsculas, números e hifens."
  }
}

variable "region" {
  description = "Região AWS para o provider."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "A região não pode ser vazia."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group (componente '<finalidade>' na nomenclatura). Ex.: web, db, app."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "security_group_name deve conter apenas letras minúsculas, números e hifens."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrão de IDs de VPC (ex.: vpc-abc123...)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas no recurso. As tags obrigatórias do padrão corporativo sempre serão aplicadas."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Lista de regras de entrada para o Security Group. Cada regra exige descrição. 0.0.0.0/0 e ::/0 são permitidos apenas em 443/tcp."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trim(r.description)) > 0])
    error_message = "Toda regra de entrada deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        (!contains(r.cidr_blocks, "0.0.0.0/0") && !contains(r.ipv6_cidr_blocks, "::/0"))
        ||
        (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ])
    error_message = "Regras de entrada com 0.0.0.0/0 ou ::/0 são permitidas apenas para 443/tcp (da porta 443 até a 443)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída para o Security Group. Egress é explícito (sem liberação irrestrita por padrão). Cada regra exige descrição. 0.0.0.0/0 e ::/0 são permitidos apenas em 443/tcp."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trim(r.description)) > 0])
    error_message = "Toda regra de saída deve conter uma descrição não vazia."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        (!contains(r.cidr_blocks, "0.0.0.0/0") && !contains(r.ipv6_cidr_blocks, "::/0"))
        ||
        (lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      )
    ])
    error_message = "Regras de saída com 0.0.0.0/0 ou ::/0 são permitidas apenas para 443/tcp (da porta 443 até a 443)."
  }
}
