variable "environment" {
  type        = string
  description = "Ambiente de implantacao (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/projeto ao qual o recurso pertence."

  validation {
    condition     = length(var.system) > 0
    error_message = "system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade/sufixo que identifica a IAM Policy e a IAM Role (ex.: readonly, deploy)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN unico do principal (role, user ou root) autorizado a assumir a IAM Role (trust policy)."

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(role|user|root)\\/?.*$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (role, user ou root) e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de IAM Actions permitidas na policy, respeitando o principio do menor privilegio."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions permitidas se aplicam."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN de recurso."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima, em segundos, da sessao assumida pela IAM Role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
