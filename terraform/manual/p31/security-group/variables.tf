variable "aws_region" {
  description = "Regiao AWS na qual os recursos serao gerenciados."
  type        = string

  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region nao pode ser vazia."
  }
}

variable "security_group_name" {
  description = "Sufixo descritivo do nome do Security Group."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]{1,230}$", var.security_group_name))
    error_message = "security_group_name deve ter de 1 a 230 letras, numeros, pontos, hifens ou underscores."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]{8}([0-9a-fA-F]{9})?$", var.vpc_id))
    error_message = "vpc_id deve seguir o formato vpc- seguido de 8 ou 17 caracteres hexadecimais."
  }
}

variable "environment" {
  description = "Ambiente usado no nome e nas tags do Security Group."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser dev, staging ou prod."
  }
}

variable "description" {
  description = "Justificativa funcional do Security Group."
  type        = string

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "description nao pode ser vazia."
  }
}

variable "allowed_ports" {
  description = "Portas TCP de entrada permitidas."
  type        = list(number)
  default     = []

  validation {
    condition = alltrue([
      for port in var.allowed_ports :
      port >= 1 && port <= 65535 && floor(port) == port
    ])
    error_message = "allowed_ports deve conter portas TCP inteiras entre 1 e 65535."
  }
}

variable "allowed_cidrs" {
  description = "CIDRs IPv4 autorizados nas portas de entrada. Vazio por padrao."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.allowed_cidrs :
      can(cidrnetmask(cidr)) && cidr != "0.0.0.0/0"
    ])
    error_message = "allowed_cidrs deve conter CIDRs IPv4 validos e nao pode incluir 0.0.0.0/0."
  }
}

variable "egress_rules" {
  description = "Regras TCP de saida explicitamente permitidas. Lista vazia bloqueia saida."
  type = list(object({
    description = string
    port        = number
    cidr_ipv4   = string
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      length(trimspace(rule.description)) > 0 &&
      rule.port >= 1 && rule.port <= 65535 && floor(rule.port) == rule.port &&
      can(cidrnetmask(rule.cidr_ipv4)) && rule.cidr_ipv4 != "0.0.0.0/0"
    ])
    error_message = "Cada regra de saida precisa de descricao, porta TCP valida e CIDR IPv4 diferente de 0.0.0.0/0."
  }
}

variable "additional_tags" {
  description = "Tags adicionais. Tags padrao de ambiente, projeto, gestao e nome sempre prevalecem."
  type        = map(string)
  default     = {}
}
