variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/projeto ao qual o recurso pertence."
  default     = "tcc"

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
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da policy/role IAM, usada para compor o nome padronizado do recurso (ex.: readonly, s3-access)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de principals (usuarios, roles ou contas) autorizados a assumir a IAM Role. Nao e permitido usar \"*\"."

  validation {
    condition     = length(var.trusted_principal_arns) > 0 && !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns deve conter ao menos um ARN valido e nao pode conter \"*\"."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas (Effect Allow) na policy."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
