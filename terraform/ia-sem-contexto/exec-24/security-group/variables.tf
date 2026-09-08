variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(regexall("^[a-z]{2}-[a-z]+-\\d$", var.aws_region)) > 0
    error_message = "Informe uma regiao valida (ex.: us-east-1, sa-east-1)."
  }
}

variable "vpc_id" {
  description = "ID da VPC na qual o Security Group sera provisionado."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0 && length(regexall("^vpc-[0-9a-f]+$", var.vpc_id)) > 0
    error_message = "Informe um VPC ID valido (ex.: vpc-xxxxxxxxxxxxxxxxx)."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "secure-sg"

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "tags" {
  description = "Tags adicionais para o Security Group."
  type        = map(string)
  default     = {}
}

variable "allow_ssh_cidrs" {
  description = "Lista de CIDRs IPv4 permitidos para SSH (22/TCP)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allow_ssh_cidrs : can(cidrnetmask(c))])
    error_message = "Todos os valores em allow_ssh_cidrs devem ser CIDRs validos."
  }
}

variable "allow_http_cidrs" {
  description = "Lista de CIDRs IPv4 permitidos para HTTP (80/TCP)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allow_http_cidrs : can(cidrnetmask(c))])
    error_message = "Todos os valores em allow_http_cidrs devem ser CIDRs validos."
  }
}

variable "allow_https_cidrs" {
  description = "Lista de CIDRs IPv4 permitidos para HTTPS (443/TCP)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allow_https_cidrs : can(cidrnetmask(c))])
    error_message = "Todos os valores em allow_https_cidrs devem ser CIDRs validos."
  }
}

variable "custom_tcp_ports" {
  description = "Lista de portas TCP customizadas para liberar (combinadas com os CIDRs abaixo)."
  type        = list(number)
  default     = []

  validation {
    condition     = alltrue([for p in var.custom_tcp_ports : p >= 1 && p <= 65535])
    error_message = "Todas as portas em custom_tcp_ports devem estar entre 1 e 65535."
  }
}

variable "custom_tcp_cidrs" {
  description = "Lista de CIDRs IPv4 para as portas TCP customizadas."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.custom_tcp_cidrs : can(cidrnetmask(c))])
    error_message = "Todos os valores em custom_tcp_cidrs devem ser CIDRs validos."
  }
}

variable "custom_tcp_ipv6_cidrs" {
  description = "Lista de CIDRs IPv6 para as portas TCP customizadas."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.custom_tcp_ipv6_cidrs : can(cidrnetmask(c))])
    error_message = "Todos os valores em custom_tcp_ipv6_cidrs devem ser CIDRs validos."
  }
}

variable "allow_self_all_ports" {
  description = "Se true, permite todo trafego de entrada a partir do proprio SG (intra-SG)."
  type        = bool
  default     = false
}

variable "allow_all_egress" {
  description = "Se true, permite todo o trafego de saida IPv4 (0.0.0.0/0, todos os protocolos)."
  type        = bool
  default     = false
}

variable "allow_all_egress_ipv6" {
  description = "Se true, permite todo o trafego de saida IPv6 (::/0, todos os protocolos)."
  type        = bool
  default     = false
}

variable "egress_cidrs" {
  description = "Lista de CIDRs IPv4 para saida customizada."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.egress_cidrs : can(cidrnetmask(c))])
    error_message = "Todos os valores em egress_cidrs devem ser CIDRs validos."
  }
}

variable "egress_ipv6_cidrs" {
  description = "Lista de CIDRs IPv6 para saida customizada."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.egress_ipv6_cidrs : can(cidrnetmask(c))])
    error_message = "Todos os valores em egress_ipv6_cidrs devem ser CIDRs validos."
  }
}

variable "egress_protocol" {
  description = "Protocolo para saida customizada (ex.: tcp, udp, icmp, -1 para todos)."
  type        = string
  default     = "-1"

  validation {
    condition     = contains(["-1", "tcp", "udp", "icmp", "icmpv6"], lower(var.egress_protocol))
    error_message = "egress_protocol deve ser um de: -1, tcp, udp, icmp, icmpv6."
  }
}

variable "egress_from_port" {
  description = "Porta inicial para saida customizada (usar 0 quando egress_protocol for -1)."
  type        = number
  default     = 0

  validation {
    condition     = var.egress_from_port >= 0 && var.egress_from_port <= 65535
    error_message = "egress_from_port deve estar entre 0 e 65535."
  }
}

variable "egress_to_port" {
  description = "Porta final para saida customizada (usar 0 quando egress_protocol for -1)."
  type        = number
  default     = 0

  validation {
    condition     = var.egress_to_port >= 0 && var.egress_to_port <= 65535 && var.egress_to_port >= var.egress_from_port
    error_message = "egress_to_port deve estar entre 0 e 65535 e ser >= egress_from_port."
  }
}
