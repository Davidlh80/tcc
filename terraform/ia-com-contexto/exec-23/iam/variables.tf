variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema ou projeto ao qual o recurso pertence, usado no padrao de nomenclatura."
  type        = string
  default     = "tcc"

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias do recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada como sufixo no padrao <ambiente>-<sistema>-iam-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy (Effect Allow). Nao pode conter \"*\" combinado com allowed_resources contendo \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "Informe ao menos uma acao em allowed_actions."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy (Effect Allow). Nao pode conter \"*\" combinado com allowed_actions contendo \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "Informe ao menos um recurso em allowed_resources."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (conta, usuario ou role) autorizado a assumir a IAM Role. Nao e permitido '*'."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN valido de conta (root), usuario ou role (ex.: arn:aws:iam::123456789012:role/nome)."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, da sessao assumida pela IAM Role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
