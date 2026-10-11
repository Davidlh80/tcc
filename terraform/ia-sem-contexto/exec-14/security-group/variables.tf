variable "region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group será provisionado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC válido, iniciando com 'vpc-'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-default"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "name deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explícitas. Vazia por padrão para evitar exposição desnecessária."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de ingress_rules, from_port deve ser menor ou igual a to_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída explícitas. Por padrão libera apenas HTTPS (443) de saída."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS de saida"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : rule.from_port <= rule.to_port
    ])
    error_message = "Em cada regra de egress_rules, from_port deve ser menor ou igual a to_port."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
