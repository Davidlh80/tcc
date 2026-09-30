variable "environment" {
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/projeto ao qual o recurso pertence, usado na composicao do nome."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens, sem iniciar ou terminar com hifen."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "O valor de region deve seguir o formato de uma regiao AWS valida, por exemplo us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias do padrao organizacional."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada na composicao do nome dos recursos (ex.: readonly, deploy, logging)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens, sem iniciar ou terminar com hifen."
  }
}

variable "policy_description" {
  description = "Descricao customizada da IAM Policy. Quando nao informada, uma descricao padrao e utilizada."
  type        = string
  default     = null
}

variable "role_description" {
  description = "Descricao customizada da IAM Role. Quando nao informada, uma descricao padrao e utilizada."
  type        = string
  default     = null
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas na statement Effect=Allow da policy (ex.: [\"s3:GetObject\", \"s3:PutObject\"])."
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

variable "trusted_principal_type" {
  description = "Tipo do principal confiavel na trust policy da role (AWS ou Service)."
  type        = string
  default     = "AWS"

  validation {
    condition     = contains(["AWS", "Service"], var.trusted_principal_type)
    error_message = "O valor de trusted_principal_type deve ser \"AWS\" ou \"Service\"."
  }
}

variable "trusted_principal_identifiers" {
  description = "Lista de identificadores do principal confiavel autorizado a assumir a role (ex.: ARN de uma role/usuario ou um service principal como ec2.amazonaws.com). Nao pode conter \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0 && !contains(var.trusted_principal_identifiers, "*")
    error_message = "trusted_principal_identifiers deve conter ao menos um identificador especifico e nao pode conter \"*\"."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, de uma sessao assumida da role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
