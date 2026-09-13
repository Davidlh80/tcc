variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, iniciando com \"vpc-\"."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "example-sg"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) do Security Group. Vazia por padrao (nenhum trafego de entrada liberado)."
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
    error_message = "Todos os cidr_blocks informados em ingress_rules devem ser blocos CIDR validos."
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
    error_message = "Todos os cidr_blocks informados em egress_rules devem ser blocos CIDR validos."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
