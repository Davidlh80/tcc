variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "A região AWS não pode ser vazia."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado (ex.: vpc-1234567890abcdef0)."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "vpc_id deve corresponder ao padrão vpc-xxxxxxxx (hex)."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Por padrão não há entradas permitidas."
  type = list(object({
    description       = optional(string, null)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    prefix_list_ids   = optional(list(string), [])
    self              = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (r.from_port >= 0 && r.to_port >= 0 && r.from_port <= r.to_port)
    ])
    error_message = "Cada regra de ingress deve possuir from_port e to_port >= 0, com from_port <= to_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída (egress). Por padrão permite todo tráfego de saída para IPv4 e IPv6."
  type = list(object({
    description       = optional(string, null)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_groups   = optional(list(string), [])
    prefix_list_ids   = optional(list(string), [])
    self              = optional(bool, false)
  }))

  default = [
    {
      description      = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (r.from_port >= 0 && r.to_port >= 0 && r.from_port <= r.to_port)
    ])
    error_message = "Cada regra de egress deve possuir from_port e to_port >= 0, com from_port <= to_port."
  }
}

variable "tags" {
  description = "Tags adicionais para aplicar ao Security Group."
  type        = map(string)
  default     = {}
}
