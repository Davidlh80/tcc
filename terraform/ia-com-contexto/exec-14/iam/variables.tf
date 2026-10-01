variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicacao proprietaria do recurso."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas as tags obrigatorias."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade/nome descritivo utilizado na nomenclatura da policy e da role (ex.: readonly, deploy)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal (usuario, role ou conta AWS) autorizado a assumir a role via sts:AssumeRole. Nao pode ser \"*\"."

  validation {
    condition     = var.trusted_principal_arn != "*" && length(var.trusted_principal_arn) > 0
    error_message = "trusted_principal_arn nao pode ser vazio nem o curinga \"*\"."
  }
}

variable "iam_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas (Effect Allow) na policy."

  validation {
    condition     = length(var.iam_actions) > 0 && var.iam_actions != ["*"]
    error_message = "iam_actions deve conter ao menos uma action e nao pode ser somente [\"*\"]."
  }
}

variable "iam_resources" {
  type        = list(string)
  description = "Lista de recursos (ARNs) aos quais as actions permitidas se aplicam."

  validation {
    condition     = length(var.iam_resources) > 0 && var.iam_resources != ["*"]
    error_message = "iam_resources deve conter ao menos um recurso e nao pode ser somente [\"*\"]."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima, em segundos, da sessao obtida ao assumir a role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
