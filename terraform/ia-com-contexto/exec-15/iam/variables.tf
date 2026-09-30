variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/projeto ao qual o recurso pertence."

  validation {
    condition     = length(var.system) > 0
    error_message = "system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "purpose" {
  type        = string
  description = "Finalidade da IAM Policy/Role, usada na nomenclatura padronizada (ex.: readonly, deploy)."

  validation {
    condition     = length(var.purpose) > 0
    error_message = "purpose nao pode ser vazio."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy criada."
  default     = "Custom least-privilege IAM policy managed via Terraform."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas na policy (principio do menor privilegio)."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma action."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs/recursos aos quais as actions permitidas se aplicam."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal IAM (conta, role ou usuario) autorizado a assumir a role. Nao pode ser curinga."

  validation {
    condition     = var.trusted_principal_arn != "*" && var.trusted_principal_arn != ""
    error_message = "trusted_principal_arn nao pode ser vazio nem \"*\". Informe um ARN especifico."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (ex.: arn:aws:iam::123456789012:role/nome)."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) da sessao assumida pela role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
