variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera provisionado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, no formato vpc-xxxxxxxx."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-default"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) do Security Group. Nenhuma porta e aberta por padrao."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue(flatten([
      for rule in var.ingress_rules : [
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Todos os cidr_blocks informados em ingress_rules devem ser blocos CIDR validos."
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : rule.from_port >= 0 && rule.to_port >= rule.from_port])
    error_message = "Em ingress_rules, from_port deve ser >= 0 e to_port deve ser >= from_port."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress) do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue(flatten([
      for rule in var.egress_rules : [
        for cidr in rule.cidr_blocks : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Todos os cidr_blocks informados em egress_rules devem ser blocos CIDR validos."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
