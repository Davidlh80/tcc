variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group será provisionado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC válido, no formato vpc-xxxxxxxx."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-app-exemplo"
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform com regras explicitas de entrada e saida."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS originado da rede interna confiavel"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "Permite trafego SSH originado da rede de administracao"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/24"]
    }
  ]

  validation {
    condition     = alltrue([for rule in var.ingress_rules : rule.from_port <= rule.to_port])
    error_message = "Em cada regra de ingress_rules, from_port deve ser menor ou igual a to_port."
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : !contains(rule.cidr_blocks, "0.0.0.0/0")])
    error_message = "Regras de entrada (ingress_rules) nao podem usar o CIDR irrestrito 0.0.0.0/0."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS de saida para atualizacoes e dependencias externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite resolucao DNS de saida"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition     = alltrue([for rule in var.egress_rules : rule.from_port <= rule.to_port])
    error_message = "Em cada regra de egress_rules, from_port deve ser menor ou igual a to_port."
  }
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
