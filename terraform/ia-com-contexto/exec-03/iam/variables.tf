variable "environment" {
  description = "Ambiente de implantacao do recurso. Deve ser um dos valores padronizados pela organizacao (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome curto do sistema ou aplicacao ao qual o recurso pertence. Usado no padrao de nomenclatura <ambiente>-<sistema>-<recurso>-<finalidade>."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/identificador da policy e da role (ex.: 'readonly', 's3-access'). Usado como ultimo segmento do padrao de nomenclatura."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "iam_actions" {
  description = "Lista de IAM Actions permitidas na statement Allow da policy. Nao pode ser combinada com iam_resources = [\"*\"] (Action \"*\" + Resource \"*\" e proibido)."
  type        = list(string)

  validation {
    condition     = length(var.iam_actions) > 0
    error_message = "iam_actions deve conter ao menos uma action."
  }
}

variable "iam_resources" {
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy. Nao pode ser combinada com iam_actions = [\"*\"] (Action \"*\" + Resource \"*\" e proibido)."
  type        = list(string)

  validation {
    condition     = length(var.iam_resources) > 0
    error_message = "iam_resources deve conter ao menos um resource."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico (conta, usuario ou role) autorizado a assumir esta IAM Role via sts:AssumeRole. Nao pode ser wildcard."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (conta, usuario ou role) e nao pode ser \"*\"."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, da sessao obtida ao assumir a role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
