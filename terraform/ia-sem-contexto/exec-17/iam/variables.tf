variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy."

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter de 1 a 128 caracteres validos para IAM (letras, numeros e os simbolos + = , . @ _ -)."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Managed by Terraform."
}

variable "policy_path" {
  type        = string
  description = "Path da IAM Policy dentro da conta AWS."
  default     = "/"

  validation {
    condition     = can(regex("^/([\\w+=,.@-]+/)*$", var.policy_path))
    error_message = "policy_path deve comecar e terminar com '/' e conter apenas caracteres validos para paths do IAM."
  }
}

variable "allow_wildcard_actions" {
  type        = bool
  description = "Quando true, permite statements com acao wildcard total ('*'). Mantenha false para seguir o principio de privilegio minimo."
  default     = false
}

variable "statements" {
  description = "Lista de statements da IAM Policy Document a serem gerados."
  type = list(object({
    sid    = optional(string)
    effect = string
    actions   = list(string)
    resources = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))

  default = [
    {
      sid       = "AllowDescribeEC2Instances"
      effect    = "Allow"
      actions   = ["ec2:DescribeInstances"]
      resources = ["*"]
    }
  ]

  validation {
    condition     = alltrue([for s in var.statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo 'effect' de cada statement deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.actions) > 0])
    error_message = "Cada statement deve conter ao menos uma acao em 'actions'."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.resources) > 0])
    error_message = "Cada statement deve conter ao menos um recurso em 'resources'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Policy."
  default     = {}
}
