variable "policy_name" {
  description = "Nome da policy IAM a ser criada"
  type        = string
}

variable "role_name" {
  description = "Nome da role IAM a ser criada"
  type        = string
}

variable "environment" {
  description = "Ambiente de implantacao (ex: dev, prd)"
  type        = string

  validation {
    condition     = contains(["dev", "prd"], var.environment)
    error_message = "O valor da variavel 'environment' deve ser 'dev' ou 'prd'."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal autorizado a assumir a role"
  type        = string

  validation {
    condition = can(regex(
      "^arn:aws[a-z-]*:iam::[0-9]{12}:(root|(role|user)/[A-Za-z0-9+=,.@_/-]+)$",
      var.trusted_principal_arn
    ))
    error_message = "trusted_principal_arn deve ser um ARN IAM especifico, sem curinga."
  }
}

variable "allowed_actions" {
  description = "Acoes IAM permitidas pela policy (ex: s3:GetObject)"
  type        = list(string)

  validation {
    condition = length(var.allowed_actions) > 0 && alltrue([
      for action in var.allowed_actions : can(regex("^[a-z0-9-]+:[A-Za-z][A-Za-z0-9]*$", action))
    ])
    error_message = "allowed_actions deve conter acoes explicitas, sem curinga."
  }
}

variable "allowed_resources" {
  description = "ARNs dos recursos liberados pela policy"
  type        = list(string)

  validation {
    condition = length(var.allowed_resources) > 0 && alltrue([
      for arn in var.allowed_resources : startswith(arn, "arn:")
    ])
    error_message = "allowed_resources deve conter apenas ARNs explicitos."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos IAM"
  type        = map(string)
  default     = {}
}
