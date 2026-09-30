variable "environment" {
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)"
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema/aplicacao dono do recurso, usado no padrao de nomenclatura"
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS utilizada pelo provider"
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias da organizacao"
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada como sufixo no padrao de nomenclatura <ambiente>-<sistema>-<recurso>-<finalidade>"
  type        = string

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal IAM (root, usuario ou role) autorizado a assumir a role criada. Nao e permitido usar '*'."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (root, user ou role) e nao pode ser '*'."
  }
}

variable "policy_actions" {
  description = "Lista de actions IAM permitidas (Effect Allow) na policy"
  type        = list(string)

  validation {
    condition     = length(var.policy_actions) > 0
    error_message = "policy_actions deve conter pelo menos uma action."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos permitidos (Effect Allow) na policy"
  type        = list(string)

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources deve conter pelo menos um recurso (ARN)."
  }
}
