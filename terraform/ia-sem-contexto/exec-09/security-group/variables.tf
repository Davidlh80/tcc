variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve estar no formato padrão AWS (ex.: us-east-1)."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC válido (ex.: vpc-123abcde ou vpc-1234567890abcdef0)."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "tf-sg"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255 && can(regex("^[0-9A-Za-z._-]+$", var.name))
    error_message = "name deve ter entre 1 e 255 caracteres e conter apenas letras, números, ponto, underscore e hífen."
  }
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform"
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "Regras de entrada (ingress) do Security Group."
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.from_port <= r.to_port
    ])
    error_message = "Cada regra de ingress deve ter from_port/to_port entre 0 e 65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "O protocolo em ingress_rules deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }
}

variable "egress_rules" {
  description = "Regras de saída (egress) do Security Group."
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = [
    {
      description      = "Permitir todo tráfego de saída IPv4"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
    },
    {
      description      = "Permitir todo tráfego de saída IPv6"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = []
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      self             = false
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      r.from_port >= 0 && r.from_port <= 65535 &&
      r.to_port >= 0 && r.to_port <= 65535 &&
      r.from_port <= r.to_port
    ])
    error_message = "Cada regra de egress deve ter from_port/to_port entre 0 e 65535 e from_port <= to_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(r.protocol))
    ])
    error_message = "O protocolo em egress_rules deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }
}
