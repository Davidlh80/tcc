variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou projeto ao qual o recurso pertence."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,32}$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens (ate 32 caracteres)."
  }
}

variable "region" {
  description = "Regiao da AWS onde o recurso sera provisionado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de uma regiao AWS valida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada na composicao do nome padronizado do recurso (ex.: readonly)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,64}$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens (ate 64 caracteres)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform seguindo o padrao organizacional."
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na statement Allow da policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }

  validation {
    condition     = !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode conter a acao curinga \"*\"."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }

  validation {
    condition     = !contains(var.allowed_resources, "*")
    error_message = "allowed_resources nao pode conter o recurso curinga \"*\"."
  }
}
