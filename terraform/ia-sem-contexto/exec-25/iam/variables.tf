variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve estar no formato padrão, por exemplo: us-east-1, eu-west-1."
  }
}

variable "policy_name" {
  description = "Nome explícito da IAM Policy. Se não definido, será usado policy_name_prefix."
  type        = string
  default     = null

  validation {
    condition     = var.policy_name == null || can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter de 1 a 128 caracteres válidos: A-Za-z0-9+=,.@_-."
  }
}

variable "policy_name_prefix" {
  description = "Prefixo para o nome da IAM Policy (Terraform gerará um sufixo único). Use null se 'policy_name' for definido."
  type        = string
  default     = "tf-iam-policy-"

  validation {
    condition     = var.policy_name_prefix == null || can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.policy_name_prefix))
    error_message = "policy_name_prefix deve conter de 1 a 64 caracteres válidos: A-Za-z0-9+=,.@_-."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Managed IAM policy provisioned by Terraform."
}

variable "path" {
  description = "Caminho da IAM Policy."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/(|[A-Za-z0-9+=,.@_-]+/)*$", var.path))
    error_message = "path deve começar com '/', opcionalmente conter segmentos válidos e encerrar com '/'. Ex: '/', '/service-role/'."
  }
}

variable "statements" {
  description = "Lista de declarações (statements) da policy."
  type = list(object({
    sid       = optional(string)
    effect    = optional(string)                 # Allow | Deny
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
      sid       = "ReadCallerIdentity"
      effect    = "Allow"
      actions   = ["sts:GetCallerIdentity", "iam:ListAccountAliases"]
      resources = ["*"]
    }
  ]

  validation {
    condition = alltrue([
      for s in var.statements :
      length(s.actions) > 0 && length(s.resources) > 0 &&
      (try(upper(s.effect), "ALLOW") == "ALLOW" || try(upper(s.effect), "ALLOW") == "DENY")
    ])
    error_message = "Cada statement deve ter pelo menos uma action, pelo menos um resource e effect deve ser Allow ou Deny (case-insensitive)."
  }
}

variable "tags" {
  description = "Tags a aplicar no recurso."
  type        = map(string)
  default     = {}
}
