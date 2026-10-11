variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera provisionado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, no formato vpc-xxxxxxxx."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-custom"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform com regras explicitas de entrada e saida."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas. Vazio por padrao (sem acesso de entrada liberado)."
  type = list(object({
    description      = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de ingress, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : !contains(coalesce(rule.cidr_blocks, []), "0.0.0.0/0")
    ])
    error_message = "Regras de ingress nao devem usar 0.0.0.0/0. Especifique CIDRs restritos."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas."
  type = list(object({
    description      = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
  }))
  default = [
    {
      description      = "Permite saida HTTPS para a internet"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de egress, from_port deve ser menor ou igual a to_port."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
