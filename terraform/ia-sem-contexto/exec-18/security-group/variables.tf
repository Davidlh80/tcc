variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera provisionado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC valido, no formato 'vpc-xxxxxxxx'."
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
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."

  validation {
    condition     = length(var.description) > 0
    error_message = "description nao pode ser vazia."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra define portas, protocolo, descricao e CIDRs de origem permitidos."
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
      for rule in var.ingress_rules : alltrue([
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ])
    ])
    error_message = "Todos os cidr_blocks em ingress_rules devem ser blocos CIDR validos."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      rule.from_port >= 0 && rule.to_port <= 65535 && rule.from_port <= rule.to_port
    ])
    error_message = "As portas em ingress_rules devem estar entre 0 e 65535, com from_port menor ou igual a to_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida. Cada regra define portas, protocolo, descricao e CIDRs de destino permitidos."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite todo o trafego de saida"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : alltrue([
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ])
    ])
    error_message = "Todos os cidr_blocks em egress_rules devem ser blocos CIDR validos."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      rule.from_port >= 0 && rule.to_port <= 65535 && rule.from_port <= rule.to_port
    ])
    error_message = "As portas em egress_rules devem estar entre 0 e 65535, com from_port menor ou igual a to_port."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
