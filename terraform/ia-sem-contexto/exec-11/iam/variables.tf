variable "aws_region" {
  description = "Região AWS onde os recursos serão gerenciados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}(-gov)?-[a-z]+-\\d+$", var.aws_region)) || can(regex("^us-iso(-b)?-[a-z]+-\\d+$", var.aws_region))
    error_message = "aws_region deve ser uma região AWS válida, por exemplo: us-east-1, us-west-2, us-gov-west-1, us-iso-east-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada."
  type        = string
  default     = "custom-managed-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter até 128 caracteres e conter apenas A-Za-z0-9+=,.@_-"
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Customer managed policy gerada via Terraform."
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve começar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^(/|(/[A-Za-z0-9+=,.@_-]+)+/)$", var.policy_path))
    error_message = "policy_path deve começar e terminar com '/', por exemplo '/', '/service-role/', '/app/prod/'."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas à IAM Policy."
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "Lista de statements para compor o documento da policy."
  type = list(object({
    sid           = optional(string)
    effect        = optional(string)                  # Allow | Deny
    actions       = optional(list(string))            # Não usar junto com not_actions
    not_actions   = optional(list(string))            # Não usar junto com actions
    resources     = optional(list(string))            # Não usar junto com not_resources
    not_resources = optional(list(string))            # Não usar junto com resources
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))

  # Padrão seguro e útil: introspecção mínima sem permissões de escrita
  default = [
    {
      sid      = "Introspection"
      effect   = "Allow"
      actions  = ["sts:GetCallerIdentity", "iam:ListAccountAliases"]
      resources = ["*"]
    }
  ]

  validation {
    condition = alltrue([
      for s in var.statements :
      (
        (contains(keys(s), "actions") || contains(keys(s), "not_actions"))
        &&
        !(contains(keys(s), "actions") && contains(keys(s), "not_actions"))
      )
    ])
    error_message = "Cada statement deve definir apenas um entre actions OU not_actions, e pelo menos um deles."
  }

  validation {
    condition = alltrue([
      for s in var.statements :
      (
        (contains(keys(s), "resources") || contains(keys(s), "not_resources"))
        &&
        !(contains(keys(s), "resources") && contains(keys(s), "not_resources"))
      )
    ])
    error_message = "Cada statement deve definir apenas um entre resources OU not_resources, e pelo menos um deles."
  }

  validation {
    condition = alltrue([
      for s in var.statements :
      (
        !contains(keys(s), "effect")
        || upper(s.effect) == "ALLOW"
        || upper(s.effect) == "DENY"
      )
    ])
    error_message = "effect deve ser Allow ou Deny quando definido."
  }

  validation {
    condition = alltrue([
      for s in var.statements :
      (
        !contains(keys(s), "actions") || length(try(s.actions, [])) > 0
      )
    ])
    error_message = "Quando definido, actions não pode ser uma lista vazia."
  }

  validation {
    condition = alltrue([
      for s in var.statements :
      (
        !contains(keys(s), "not_actions") || length(try(s.not_actions, [])) > 0
      )
    ])
    error_message = "Quando definido, not_actions não pode ser uma lista vazia."
  }

  validation {
    condition = alltrue([
      for s in var.statements :
      (
        !contains(keys(s), "resources") || length(try(s.resources, [])) > 0
      )
    ])
    error_message = "Quando definido, resources não pode ser uma lista vazia."
  }

  validation {
    condition = alltrue([
      for s in var.statements :
      (
        !contains(keys(s), "not_resources") || length(try(s.not_resources, [])) > 0
      )
    ])
    error_message = "Quando definido, not_resources não pode ser uma lista vazia."
  }
}
