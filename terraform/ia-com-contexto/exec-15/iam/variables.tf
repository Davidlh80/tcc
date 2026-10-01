variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema ou projeto ao qual o recurso pertence, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve ser nao vazio e conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "region deve seguir o formato de uma regiao AWS valida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/nome da IAM Policy e da IAM Role, usado na nomenclatura padronizada (<ambiente>-<sistema>-<recurso>-<finalidade>)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve ser nao vazio e conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal (usuario, role ou conta) autorizado a assumir a IAM Role. Nao pode ser um wildcard."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:", var.trusted_principal_arn)) && !can(regex("\\*", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (arn:aws:iam::<account-id>:...) e nao pode conter wildcard."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy. Nao deve conter apenas \"*\" combinado com allowed_resources igual a \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}
