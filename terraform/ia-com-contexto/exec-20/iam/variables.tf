variable "environment" {
  type        = string
  description = "Ambiente de implantacao dos recursos (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicacao ao qual os recursos IAM pertencem, usado na nomenclatura padronizada."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS usada pelo provider (IAM e um servico global, mas a regiao define o endpoint da API)."

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "O valor de region deve seguir o formato de uma regiao AWS valida, ex.: us-east-1."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais mescladas as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy/Role, usada para compor o nome padronizado (ex.: readonly, deploy, backup)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas na policy, seguindo o principio do menor privilegio."

  validation {
    condition     = length(var.allowed_actions) > 0 && !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "allowed_actions nao pode ser vazio nem combinar Action \"*\" com Resource \"*\" (ver allowed_resources)."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs/recursos aos quais as actions permitidas em allowed_actions se aplicam."

  validation {
    condition     = length(var.allowed_resources) > 0 && !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "allowed_resources nao pode ser vazio nem combinar Resource \"*\" com Action \"*\" (ver allowed_actions)."
  }
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de principals AWS autorizados a assumir a role via sts:AssumeRole. Nao e permitido usar \"*\"."

  validation {
    condition = length(var.trusted_principal_arns) > 0 && alltrue([
      for principal in var.trusted_principal_arns : principal != "*" && principal != "arn:aws:iam::*:root"
    ])
    error_message = "trusted_principal_arns deve conter ao menos um ARN especifico e nao pode conter \"*\" nem um curinga de conta (arn:aws:iam::*:root)."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) da sessao assumida via sts:AssumeRole."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
