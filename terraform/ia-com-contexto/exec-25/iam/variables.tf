variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema ou produto ao qual o recurso pertence, usado no padrao de nomenclatura."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de regiao AWS, ex.: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias do recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada como sufixo no padrao de nomenclatura (ex.: readonly)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy de menor privilegio gerenciada via Terraform."
}

variable "trusted_principal_arn" {
  description = "ARN do principal especifico autorizado a assumir a IAM Role (proibido \"*\")."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:(iam|sts)::[0-9]{12}:", var.trusted_principal_arn))
    error_message = "O valor de trusted_principal_arn deve ser um ARN valido de conta/role/usuario AWS e nao pode ser \"*\"."
  }
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na policy (proibido \"*\" combinado com allowed_resources \"*\")."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as acoes permitidas se aplicam."
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
    error_message = "O valor de max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
