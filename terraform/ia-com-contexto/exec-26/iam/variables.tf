variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  default     = "tcc"
  description = "Nome do sistema/projeto utilizado na composicao do nome dos recursos (padrao <ambiente>-<sistema>-<recurso>-<finalidade>)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Regiao AWS onde os recursos IAM serao gerenciados."
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
}

variable "policy_name" {
  type        = string
  description = "Finalidade/sufixo que identifica a policy e a role (ex.: readonly, deploy). Usado na composicao do nome dos recursos."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao pode ser um wildcard."

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::\\d{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN valido de usuario, role ou root de uma conta AWS especifica, sem uso de \"*\"."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas na statement Allow da policy (principio do menor privilegio). Nao pode ser combinada com allowed_resources = [\"*\"] quando contiver \"*\"."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos na statement Allow da policy. Nao pode ser combinada com allowed_actions = [\"*\"] quando contiver \"*\"."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
