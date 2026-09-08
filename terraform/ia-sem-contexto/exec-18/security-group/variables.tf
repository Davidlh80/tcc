variable "aws_region" {
  description = "Região AWS para o provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(trim(var.aws_region)) > 0
    error_message = "aws_region não pode ser vazio."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado (ex.: vpc-12345678 ou vpc-1234567890abcdef0)."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrão de IDs de VPC (ex.: vpc-12345678 ou vpc-1234567890abcdef0)."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(trim(var.name)) > 0 && length(var.name) <= 255
    error_message = "name deve ser não vazio e ter no máximo 255 caracteres."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada item é um objeto com possíveis chaves: description (string), from_port (number), to_port (number), protocol (string), cidr_blocks (list(string)), ipv6_cidr_blocks (list(string)), security_groups (list(string)), prefix_list_ids (list(string))."
  type        = list(map(any))
  default     = []

  validation {
    condition     = var.ingress_rules == null || length(var.ingress_rules) >= 0
    error_message = "ingress_rules deve ser uma lista (pode ser vazia)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída. Cada item é um objeto com possíveis chaves: description (string), from_port (number), to_port (number), protocol (string), cidr_blocks (list(string)), ipv6_cidr_blocks (list(string)), security_groups (list(string)), prefix_list_ids (list(string))."
  type        = list(map(any))
  default = [
    {
      description = "Permitir toda saída IPv4"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description      = "Permitir toda saída IPv6"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  validation {
    condition     = var.egress_rules == null || length(var.egress_rules) >= 0
    error_message = "egress_rules deve ser uma lista (pode ser vazia)."
  }
}

variable "tags" {
  description = "Tags adicionais para o Security Group."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(trim(k)) > 0 && length(trim(v)) > 0])
    error_message = "Todas as chaves e valores em tags devem ser não vazios."
  }
}
