variable "environment" {
  type        = string
  description = "Ambiente da implantação (dev, hml, prd)."
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicação (minúsculo, números e hífens)."
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Região AWS para o provider (ex.: us-east-1)."
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve corresponder ao padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem aplicadas ao recurso. Não sobrescreva as tags obrigatórias."
  default     = {}

  validation {
    condition = length([
      for k in keys(var.additional_tags) :
      k if contains(["Project", "Environment", "ManagedBy", "Owner", "CostCenter"], k)
    ]) == 0
    error_message = "additional_tags não deve conter as chaves reservadas: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}

variable "policy_name" {
  type        = string
  description = "Finalidade da policy conforme padrão de nomenclatura (ex.: readonly, s3-access)."
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "policy_path" {
  type        = string
  description = "Caminho (path) da IAM Policy (padrão '/')."
  default     = "/"
  validation {
    condition     = can(regex("^/.*/?$", var.policy_path))
    error_message = "policy_path deve iniciar com '/' e opcionalmente terminar com '/'."
  }
}

variable "policy_description" {
  type        = string
  description = "Descrição da IAM Policy."
  default     = null
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de ações explícitas permitidas na policy (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions não pode ser vazio."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos na policy."
  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources não pode ser vazio."
  }
}
