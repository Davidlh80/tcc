variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve estar no formato de região AWS válido, por exemplo: us-east-1."
  }
}

variable "policy_name" {
  description = "Nome amigável da IAM Policy (1-128 chars, [A-Za-z0-9+=,.@-_])."
  type        = string
  default     = "example-readonly-policy"
  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve corresponder ao padrão AWS: [\\w+=,.@-]{1,128}."
  }
}

variable "path" {
  description = "Caminho da policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"
  validation {
    condition     = startswith(var.path, "/") && endswith(var.path, "/")
    error_message = "path deve iniciar e terminar com '/'."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Managed policy created by Terraform."
}

variable "effect" {
  description = "Efeito padrão da declaração principal ('Allow' ou 'Deny')."
  type        = string
  default     = "Allow"
  validation {
    condition     = contains(["allow", "deny"], lower(var.effect))
    error_message = "effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "actions" {
  description = "Ações IAM para a declaração principal."
  type        = list(string)
  default     = ["iam:GetAccountSummary"]
  validation {
    condition     = length(var.actions) > 0 && alltrue([for a in var.actions : length(trimspace(a)) > 0])
    error_message = "actions deve conter ao menos uma ação não vazia."
  }
}

variable "resources" {
  description = "Recursos IAM para a declaração principal (ex.: '*', ou ARNs)."
  type        = list(string)
  default     = ["*"]
  validation {
    condition     = length(var.resources) > 0 && alltrue([for r in var.resources : length(trimspace(r)) > 0])
    error_message = "resources deve conter ao menos um recurso não vazio (ex.: '*', arn:...)."
  }
}

variable "additional_statements" {
  description = "Lista de declarações adicionais para compor o documento da policy."
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []
  validation {
    condition = alltrue([
      for s in var.additional_statements :
      contains(["allow", "deny"], lower(s.effect))
      && length(s.actions) > 0
      && length(s.resources) > 0
      && alltrue([for a in s.actions : length(trimspace(a)) > 0])
      && alltrue([for r in s.resources : length(trimspace(r)) > 0])
    ])
    error_message = "Cada declaração adicional deve ter effect 'Allow' ou 'Deny', e listas não vazias de actions e resources."
  }
}

variable "policy_json" {
  description = "JSON completo de uma IAM Policy. Quando definido, substitui o documento gerado por actions/resources/effect."
  type        = string
  default     = null
  validation {
    condition     = var.policy_json == null ? true : (length(trimspace(var.policy_json)) > 0 && can(jsondecode(var.policy_json)))
    error_message = "policy_json, quando definido, deve ser JSON válido e não vazio."
  }
}

variable "tags" {
  description = "Tags adicionais a aplicar na policy."
  type        = map(string)
  default     = {}
}
