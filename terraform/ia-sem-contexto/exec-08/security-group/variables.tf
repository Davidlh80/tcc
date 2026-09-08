variable "aws_region" {
  description = "Região AWS onde o Security Group será criado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve estar no formato válido de região AWS (ex: us-east-1)."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-fA-F]{8}|[0-9a-fA-F]{17})$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao formato 'vpc-xxxxxxxx' ou 'vpc-xxxxxxxxxxxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group. Se não definido, será usado name_prefix."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || (length(var.name) > 0 && length(var.name) <= 128)
    error_message = "Se definido, name deve ter entre 1 e 128 caracteres."
  }
}

variable "name_prefix" {
  description = "Prefixo do nome do Security Group, usado quando name é nulo."
  type        = string
  default     = "tf-sg-"

  validation {
    condition     = length(var.name_prefix) > 0 && length(var.name_prefix) <= 64
    error_message = "name_prefix deve ter entre 1 e 64 caracteres."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"

  validation {
    condition     = length(var.description) > 0 && length(var.description) <= 255
    error_message = "description deve ter entre 1 e 255 caracteres."
  }
}

variable "revoke_rules_on_delete" {
  description = "Revoga regras existentes quando o SG é destruído. Recomendado manter true."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) para o Security Group."
  type = list(object({
    description      = optional(string, null)
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
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress) para o Security Group."
  type = list(object({
    description      = optional(string, null)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = [
    {
      description      = "Permitir toda saída IPv4"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Permitir toda saída IPv6"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = []
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

variable "tags" {
  description = "Tags adicionais a serem associadas ao Security Group."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(trim(k)) > 0 && length(v) <= 256])
    error_message = "Chaves de tags não podem ser vazias e valores devem ter até 256 caracteres."
  }
}
