variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou produto ao qual o recurso pertence, usado na padronizacao de nomes."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/identificador da policy e da role (ex.: readonly, deploy, logs), usado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal (usuario, role ou conta) autorizado a assumir a IAM Role. Nao e permitido usar curinga."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z0-9-]*:iam::\\d{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (root, user ou role) de uma conta especifica. Curingas como \"*\" nao sao permitidos."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as allowed_actions se aplicam (Effect: Allow)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
