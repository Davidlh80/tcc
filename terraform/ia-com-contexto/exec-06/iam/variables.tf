variable "region" {
  description = "Região AWS onde o recurso será provisionado (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(regexall("^[a-z]{2}(?:-gov)?-[a-z]+-[0-9]+$", var.region)) > 0
    error_message = "A variável region deve estar no formato de região AWS válido (ex.: us-east-1, us-gov-west-1)."
  }
}

variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], lower(var.environment))
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto (minúsculas, números e hífen)."
  type        = string

  validation {
    condition     = length(var.system) > 0 && length(regexall("^[a-z0-9-]+$", var.system)) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao recurso. Chaves obrigatórias organizacionais serão priorizadas em caso de conflito."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy (usado no padrão de nomenclatura <env>-<system>-iam-<policy_name>)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && length(regexall("^[a-z0-9-]+$", var.policy_name)) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descrição opcional da IAM Policy."
  type        = string
  default     = null
}

variable "permitted_actions" {
  description = "Lista de ações explícitas a permitir (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.permitted_actions) > 0 && alltrue([for a in var.permitted_actions : trim(a) != ""])
    error_message = "permitted_actions deve conter pelo menos uma ação válida e não pode incluir strings vazias."
  }
}

variable "permitted_resources" {
  description = "Lista de ARNs de recursos sobre os quais as ações são permitidas (ex.: [\"arn:aws:s3:::meu-bucket\", \"arn:aws:s3:::meu-bucket/*\"])."
  type        = list(string)

  validation {
    condition     = length(var.permitted_resources) > 0 && alltrue([for r in var.permitted_resources : trim(r) != ""])
    error_message = "permitted_resources deve conter pelo menos um ARN válido e não pode incluir strings vazias."
  }
}
