variable "environment" {
  description = "Ambiente do recurso (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos valores permitidos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/projeto (minúsculo, números e hífens)."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o padrão, por exemplo: us-east-1, eu-west-1, sa-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais (não sobrescrevem as obrigatórias)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da política (usado no padrão de nome: <env>-<system>-iam-<policy_name>, ex.: readonly)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada por Terraform conforme padrão organizacional."
}

variable "allowed_actions" {
  description = "Lista de ações explícitas a serem permitidas (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : length(trim(a)) > 0])
    error_message = "allowed_actions não pode ser vazio e não pode conter strings vazias."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos sobre os quais as ações serão permitidas."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : length(trim(r)) > 0])
    error_message = "allowed_resources não pode ser vazio e não pode conter strings vazias."
  }
}

variable "policy_path" {
  description = "Caminho da IAM Policy (deve iniciar com '/', recomendado terminar com '/')."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.policy_path, "/") && (var.policy_path == "/" || endswith(var.policy_path, "/"))
    error_message = "policy_path deve iniciar com '/' e ser '/' ou terminar com '/'."
  }
}
