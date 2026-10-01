variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um entre: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Identificador curto do sistema/aplicacao, usado na composicao do nome padronizado."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade/proposito da policy e da role, usado na composicao do nome padronizado (ex.: readonly, deploy)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de IAM Actions permitidas na statement Allow da policy. Nao pode ser combinada com allowed_resources = [\"*\"] quando contiver \"*\"."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma action."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs/recursos permitidos na statement Allow da policy. Nao pode ser combinada com allowed_actions = [\"*\"] quando contiver \"*\"."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir a role via sts:AssumeRole. Nao pode ser \"*\"."

  validation {
    condition     = var.trusted_principal_arn != "*" && length(var.trusted_principal_arn) > 0
    error_message = "trusted_principal_arn nao pode ser vazio nem \"*\"."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) da sessao assumida via sts:AssumeRole."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
