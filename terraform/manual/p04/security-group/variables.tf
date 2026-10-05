variable "region" {
  description = "Região AWS onde o sg será criado."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prd."
  }
}

variable "security_group_name" {
  description = "Nome do sg."
  type        = string

  validation {
    condition     = length(var.security_group_name) > 0 && length(var.security_group_name) <= 255 && !startswith(var.security_group_name, "sg-")
    error_message = "O nome deve ter de 1 a 255 caracteres e não pode começar com sg-."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o sg será criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "O ID da VPC deve estar no formato vpc-xxxxxxxx."
  }
}

variable "allowed_ports" {
  description = "Portas TCP liberadas na entrada."
  type        = list(number)
  default     = [443]

  validation {
    condition     = length(var.allowed_ports) > 0 && alltrue([for port in var.allowed_ports : port >= 1 && port <= 65535 && floor(port) == port])
    error_message = "Informe ao menos uma porta inteira entre 1 e 65535."
  }
}

variable "allowed_cidrs" {
  description = "CIDRs IPv4 autorizados a acessar as portas de entrada. Abertura para 0.0.0.0/0 não é permitida."
  type        = list(string)

  validation {
    condition     = length(var.allowed_cidrs) > 0 && alltrue([for cidr in var.allowed_cidrs : can(cidrhost(cidr, 0)) && cidr != "0.0.0.0/0"])
    error_message = "Informe ao menos um CIDR IPv4 válido; 0.0.0.0/0 não é permitido."
  }
}

variable "egress_ports" {
  description = "Portas TCP liberadas na saída."
  type        = list(number)
  default     = [443]

  validation {
    condition     = alltrue([for port in var.egress_ports : port >= 1 && port <= 65535 && floor(port) == port])
    error_message = "As portas de saída devem ser inteiros entre 1 e 65535."
  }
}

variable "egress_cidrs" {
  description = "CIDRs IPv4 de destino liberados na saída. Quando vazio, usa allowed_cidrs."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.egress_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Todos os CIDRs de saída devem ser IPv4 válidos."
  }
}

variable "additional_tags" {
  description = "Tags adicionais aplicadas ao sg, somadas às tags obrigatórias."
  type        = map(string)
  default     = {}
}
