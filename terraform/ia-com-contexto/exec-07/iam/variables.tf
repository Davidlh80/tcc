variable "environment" {
  description = "Ambiente alvo do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o padrão de regiões AWS, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso. Tags obrigatórias internas prevalecem em caso de conflito."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Nome lógico da policy (finalidade), usado na composição <environment>-<system>-iam-<policy_name>."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM a permitir (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions não pode ser vazio."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs dos recursos a permitir (ex.: [\"arn:aws:s3:::meu-bucket\", \"arn:aws:s3:::meu-bucket/*\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources não pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM Policy criada via Terraform seguindo o princípio do menor privilégio."
}

variable "path" {
  description = "Caminho (path) da policy IAM."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/?$|^/$", var.path))
    error_message = "path deve iniciar com '/' e opcionalmente terminar com '/'."
  }
}
