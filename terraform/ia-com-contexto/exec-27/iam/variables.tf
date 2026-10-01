variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicacao ao qual o recurso pertence (ex.: tcc)."
  type        = string
  default     = "tcc"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
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
  description = "Finalidade/sufixo que identifica o proposito da IAM Policy e da IAM Role (ex.: readonly, deploy-pipeline)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao e permitido usar \"*\"."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "O valor de trusted_principal_arn deve ser um ARN IAM valido de root, user ou role (ex.: arn:aws:iam::123456789012:role/nome-da-role)."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas pela policy. Nao e permitido o valor \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma acao."
  }

  validation {
    condition     = !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode conter o valor \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as acoes permitidas se aplicam. Nao e permitido o valor \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }

  validation {
    condition     = !contains(var.allowed_resources, "*")
    error_message = "allowed_resources nao pode conter o valor \"*\"."
  }
}
