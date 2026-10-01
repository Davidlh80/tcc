variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd), usado no padrao de nomenclatura e nas tags obrigatorias."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser \"dev\", \"hml\" ou \"prd\"."
  }
}

variable "system" {
  description = "Identificador do sistema ou projeto ao qual o recurso pertence, usado no padrao de nomenclatura."
  type        = string
  default     = "tcc"

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
  description = "Tags adicionais a serem mescladas as tags obrigatorias definidas pela organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada no padrao <ambiente>-<sistema>-<recurso>-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "policy_description" {
  description = "Descricao funcional da IAM Policy criada."
  type        = string
  default     = "Custom least-privilege policy managed by Terraform."
}

variable "trusted_principal_arn" {
  description = "ARN do principal especifico (role, user ou root da conta) autorizado a assumir a IAM Role via trust policy. Nao e permitido \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z0-9-]*:iam::[0-9]{12}:(role|user|root)", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM especifico (role, user ou root) e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de IAM Actions permitidas na policy (principio do menor privilegio). Nao pode conter \"*\" combinado com allowed_resources = [\"*\"]."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos na policy (principio do menor privilegio). Nao pode conter \"*\" combinado com allowed_actions = [\"*\"]."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida pela IAM Role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
