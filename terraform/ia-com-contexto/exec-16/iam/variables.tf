variable "environment" {
  description = "Ambiente de implantacao (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema ou aplicacao ao qual o recurso pertence, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/identificador da IAM Policy, usado para compor o nome padronizado <ambiente>-<sistema>-iam-<policy_name>."
  type        = string

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform seguindo o padrao organizacional de menor privilegio."
}

variable "policy_path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "role_purpose" {
  description = "Finalidade da IAM Role, usada para compor o nome padronizado <ambiente>-<sistema>-iam-<role_purpose>."
  type        = string

  validation {
    condition     = length(trimspace(var.role_purpose)) > 0
    error_message = "role_purpose nao pode ser vazio."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform seguindo o padrao organizacional de menor privilegio."
}

variable "role_path" {
  description = "Path da IAM Role dentro do IAM."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via a IAM Role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals confiaveis autorizados a assumir a IAM Role (trust policy). Nao e permitido usar \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0 && !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns nao pode ser vazio nem conter '*'."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas (Effect: Allow) na policy. Nao pode ser combinada com allowed_resources = [\"*\"] quando esta lista contiver \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs/recursos aos quais as allowed_actions se aplicam (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
