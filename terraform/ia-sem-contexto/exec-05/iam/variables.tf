variable "aws_region" {
  description = "Região AWS para o provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve estar no formato de região AWS válida, por exemplo: us-east-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string
  default     = "readonly-s3-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres e conter apenas letras, números e os caracteres: _+=,.@-"
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy. Se não definido, será gerada uma descrição padrão."
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve começar e terminar com '/'."
  type        = string
  default     = "/customer-managed/"

  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path deve começar e terminar com '/'."
  }
}

variable "allowed_actions" {
  description = "Lista de ações AWS a serem permitidas (por exemplo, s3:GetObject)."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition = var.allow_wildcard_actions || alltrue([
      for a in var.allowed_actions :
      !can(regex("^\\*$", a)) && !can(regex(":[*]$", a))
    ])
    error_message = "allowed_actions não pode conter '*' ou 'service:*' a menos que allow_wildcard_actions=true."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as ações serão aplicadas."
  type        = list(string)
  default     = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  validation {
    condition     = var.allow_wildcard_resources || alltrue([for r in var.policy_resources : r != "*" ])
    error_message = "policy_resources não pode conter apenas '*' a menos que allow_wildcard_resources=true."
  }
}

variable "allowed_regions" {
  description = "Lista opcional de regiões permitidas via condição aws:RequestedRegion."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for r in var.allowed_regions : can(regex("^[a-z]{2}-[a-z]+-\\d$", r)) ])
    error_message = "Cada entrada de allowed_regions deve ser uma região AWS válida (ex.: us-east-1)."
  }
}

variable "allowed_source_ips" {
  description = "Lista opcional de CIDRs IPv4 permitidos via condição aws:SourceIp (pode não ser suportado por todos os serviços)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allowed_source_ips : can(cidrhost(c, 0)) ])
    error_message = "Cada entrada de allowed_source_ips deve ser um CIDR IPv4 válido (ex.: 203.0.113.0/24)."
  }
}

variable "enforce_mfa" {
  description = "Se true, adiciona uma declaração Deny para todas as ações quando MFA não estiver presente."
  type        = bool
  default     = true
}

variable "allow_wildcard_actions" {
  description = "Permite uso de '*' ou 'service:*' em allowed_actions."
  type        = bool
  default     = false
}

variable "allow_wildcard_resources" {
  description = "Permite uso do recurso '*' em policy_resources."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais para a policy."
  type        = map(string)
  default     = {}
}
