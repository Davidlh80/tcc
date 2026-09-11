variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o provider será configurado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve estar no formato válido (ex.: us-east-1)."
  }
}

variable "policy_name" {
  description = "Nome/finalidade da policy (usado no padrão <environment>-<system>-iam-<policy_name>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM permitidas (ex.: [\"s3:GetObject\", \"ec2:DescribeInstances\"]). Pode conter \"*\", mas não junto com Resource \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions não pode ser vazio."
  }

  validation {
    condition = alltrue([
      for a in var.allowed_actions :
      can(regex("^([a-z0-9-]+:[A-Za-z0-9*]+|\\*)$", a))
    ])
    error_message = "Cada ação em allowed_actions deve ser \"*\" ou no formato service:Action (ex.: s3:GetObject, s3:*, ec2:DescribeInstances)."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos para as ações. Pode incluir \"*\", mas não junto com Action \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources não pode ser vazio."
  }

  validation {
    condition = alltrue([
      for r in var.allowed_resources :
      r == "*" || can(regex("^arn:", r))
    ])
    error_message = "Cada item em allowed_resources deve ser \"*\" ou um ARN válido começando com \"arn:\"."
  }
}

variable "description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = null
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas (as tags obrigatórias do contexto sempre prevalecem)."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.additional_tags : length(trim(k)) > 0 && length(trim(v)) > 0])
    error_message = "Chaves e valores de additional_tags não podem ser vazios."
  }
}
