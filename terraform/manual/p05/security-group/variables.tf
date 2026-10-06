variable "region" {
  description = "Regiao AWS."
  type        = string
  default     = "us-east-1"
}

variable "security_group_name" {
  description = "Nome do Security Group."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prd."
  }
}

variable "allowed_ports" {
  description = "Portas TCP liberadas na entrada."
  type        = list(number)

  validation {
    condition     = alltrue([for p in var.allowed_ports : p >= 1 && p <= 65535])
    error_message = "As portas devem estar entre 1 e 65535."
  }
}

variable "allowed_cidrs" {
  description = "CIDRs IPv4 autorizados na entrada."
  type        = list(string)

  validation {
    condition     = alltrue([for c in var.allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "Todos os CIDRs devem ser validos."
  }

  validation {
    condition     = !contains(var.allowed_cidrs, "0.0.0.0/0") || alltrue([for p in var.allowed_ports : p == 443])
    error_message = "0.0.0.0/0 so e permitido para a porta 443."
  }
}

variable "egress_cidrs" {
  description = "CIDRs de destino liberados na saida (HTTPS/443)."
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "additional_tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
