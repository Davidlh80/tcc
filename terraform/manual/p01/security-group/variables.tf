variable "security_group_name" {
  description = "Nome do Security Group a ser criado"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id deve ter o formato vpc-xxxxxxxx."
  }
}

variable "environment" {
  description = "Ambiente de implantacao (ex: dev, prd)"
  type        = string

  validation {
    condition     = contains(["dev", "prd"], var.environment)
    error_message = "O valor da variavel 'environment' deve ser 'dev' ou 'prd'."
  }
}

variable "allowed_ports" {
  description = "Portas TCP liberadas na entrada"
  type        = list(number)

  validation {
    condition     = length(var.allowed_ports) > 0 && alltrue([for p in var.allowed_ports : p >= 1 && p <= 65535])
    error_message = "allowed_ports deve ter ao menos uma porta entre 1 e 65535."
  }

  validation {
    condition     = !contains(var.allowed_ports, 22) && !contains(var.allowed_ports, 3389)
    error_message = "SSH (22) e RDP (3389) nao devem ser liberados por este template."
  }
}

variable "allowed_cidrs" {
  description = "CIDRs IPv4 de origem liberados na entrada"
  type        = list(string)

  validation {
    condition     = length(var.allowed_cidrs) > 0 && alltrue([for c in var.allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "allowed_cidrs deve conter ao menos um CIDR IPv4 valido."
  }

  validation {
    condition     = !contains(var.allowed_cidrs, "0.0.0.0/0")
    error_message = "0.0.0.0/0 nao e permitido na entrada; informe faixas especificas."
  }
}

variable "egress_cidrs" {
  description = "CIDRs de destino liberados na saida (somente HTTPS)"
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition     = alltrue([for c in var.egress_cidrs : can(cidrhost(c, 0))])
    error_message = "egress_cidrs deve conter apenas CIDRs IPv4 validos."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group"
  type        = map(string)
  default     = {}
}
