variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou produto ao qual o recurso pertence, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias do padrao organizacional."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada na nomenclatura padronizada (<ambiente>-<sistema>-iam-<finalidade>)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal (role, user ou root) autorizado a assumir a IAM Role via trust policy. Nao e permitido usar \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:(role|user|root)", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN valido de role, user ou root (ex.: arn:aws:iam::123456789012:role/nome) e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de IAM Actions permitidas na policy (Effect Allow). Nao pode ser combinada com allowed_resources = [\"*\"] quando contiver \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy (Effect Allow). Nao pode ser combinada com allowed_actions = [\"*\"] quando contiver \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
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
