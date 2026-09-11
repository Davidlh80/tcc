variable "region" {
  description = "Região AWS onde os recursos serão criados (ex.: us-east-1)."
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o padrão AWS (ex.: us-east-1)."
  }
}

variable "environment" {
  description = "Ambiente de implantação (dev, hml, prd)."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculas, números e hífens)."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "additional_tags" {
  description = "Tags adicionais para os recursos (as tags obrigatórias são sempre aplicadas)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Nome da IAM Policy seguindo o padrão <environment>-<system>-iam-<finalidade> (ex.: dev-tcc-iam-readonly)."
  type        = string
  validation {
    condition     = can(regex("^${var.environment}-${var.system}-iam-[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve seguir exatamente o padrão <environment>-<system>-iam-<finalidade>, por exemplo: dev-tcc-iam-readonly."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Managed by Terraform - least privilege policy"
}

variable "allowed_actions" {
  description = "Lista de ações permitidas (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)
  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma ação."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos ou \"*\" (evitar \"*\" com ações \"*\")."
  type        = list(string)
  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
