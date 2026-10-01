variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicacao proprietaria do recurso, usado na nomenclatura padronizada."
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
  description = "Finalidade/nome da IAM Policy e da IAM Role, usada na nomenclatura padronizada (ex.: readonly, logs-writer)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal especifico autorizado a assumir a IAM Role (trust policy). Nao pode ser curinga."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::\\d{12}:(role|user|root)", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN valido de role, usuario ou conta IAM e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas (Effect Allow) na policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos (Effect Allow) na policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, da sessao assumida via a IAM Role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
