variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
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
  description = "Lista de regras de entrada (ingress) do Security Group. Vazio por padrao para negar todo trafego de entrada."
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
        for cidr in rule.cidr_blocks : can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", cidr))
      ])
    ])
    error_message = "Todos os CIDRs informados em ingress_rules devem estar em formato IPv4 CIDR valido (ex.: 10.0.0.0/16)."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress) do Security Group. Vazio por padrao para negar todo trafego de saida."
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
      for rule in var.egress_rules : alltrue([
        for cidr in rule.cidr_blocks : can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", cidr))
      ])
    ])
    error_message = "Todos os CIDRs informados em egress_rules devem estar em formato IPv4 CIDR valido (ex.: 10.0.0.0/16)."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
