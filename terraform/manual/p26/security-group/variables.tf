variable "region" {
  description = "Região AWS do provider."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de implantação (dev, hml ou prod)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prod"], var.environment)
    error_message = "O ambiente deve ser dev, hml ou prod."
  }
}

variable "security_group_name" {
  description = "Nome do Security Group."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
}

variable "allowed_ports" {
  description = "Portas TCP liberadas na entrada."
  type        = list(number)
  default     = [443]

  validation {
    condition     = alltrue([for p in var.allowed_ports : p >= 1 && p <= 65535])
    error_message = "As portas devem estar entre 1 e 65535."
  }
}

variable "allowed_cidrs" {
  description = "CIDRs IPv4 autorizados a acessar as portas liberadas."
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition     = alltrue([for c in var.allowed_cidrs : can(cidrhost(c, 0)) && c != "0.0.0.0/0"])
    error_message = "Informe CIDRs IPv4 válidos; 0.0.0.0/0 não é permitido na entrada."
  }
}

variable "egress_cidrs" {
  description = "CIDRs IPv4 de destino do tráfego HTTPS de saída. Se nulo, usa allowed_cidrs."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
