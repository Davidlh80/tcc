variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso. Deve ser um dos ambientes permitidos pela organizacao."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema/aplicacao ao qual o recurso pertence. Usado na composicao do nome padronizado."

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
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: readonly)."

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal especifico (usuario, role ou servico) autorizado a assumir a IAM Role. Nao pode ser '*'."

  validation {
    condition     = var.trusted_principal_arn != "*" && length(var.trusted_principal_arn) > 0
    error_message = "trusted_principal_arn deve ser um principal especifico e nao pode ser '*' nem vazio."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas na policy (Effect = Allow). Nao deve combinar '*' com allowed_resources contendo '*'."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma action."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions permitidas se aplicam (Effect = Allow)."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}
