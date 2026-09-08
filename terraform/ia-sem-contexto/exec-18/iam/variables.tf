variable "region" {
  type        = string
  description = "Região AWS onde o provider irá operar."
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o formato válido, por exemplo: us-east-1."
  }
}

variable "create" {
  type        = bool
  description = "Define se o recurso deve ser criado."
  default     = true
}

variable "prevent_destroy" {
  type        = bool
  description = "Protege a policy contra destruição acidental via Terraform (lifecycle.prevent_destroy)."
  default     = false
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy (deve ser único na conta)."
  default     = "example-readonly-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter apenas [A-Za-z0-9+=,.@_-] e ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  type        = string
  description = "Descrição da IAM Policy."
  default     = "Customer managed IAM policy created by Terraform."
}

variable "path" {
  type        = string
  description = "Caminho da IAM Policy (deve iniciar e terminar com '/')."
  default     = "/"

  validation {
    condition     = startswith(var.path, "/") && endswith(var.path, "/")
    error_message = "path deve iniciar e terminar com '/'. Ex: '/'."
  }
}

variable "statements" {
  description = "Lista de statements para compor o documento da policy (usado quando policy_json não é fornecido)."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    condition = map(any)
  }))
  default = [
    {
      sid       = "ReadOnlyCore"
      effect    = "Allow"
      actions   = [
        "ec2:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "logs:Describe*",
        "logs:Get*",
        "logs:List*",
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      resources = ["*"]
      condition = {}
    }
  ]

  validation {
    condition = length(var.statements) >= 1 && alltrue([
      for s in var.statements :
      contains(["allow", "deny"], lower(s.effect)) &&
      length(s.actions) > 0 &&
      length(s.resources) > 0 &&
      alltrue([for a in s.actions : length(trim(a)) > 0]) &&
      alltrue([for r in s.resources : length(trim(r)) > 0])
    ])
    error_message = "Cada statement deve ter effect Allow/Deny, pelo menos uma action e um resource não-vazios."
  }
}

variable "policy_json" {
  type        = string
  description = "JSON completo do documento da policy (substitui 'statements' quando definido)."
  default     = null

  validation {
    condition     = var.policy_json == null || trim(var.policy_json) == "" || can(jsondecode(var.policy_json))
    error_message = "policy_json deve ser um JSON válido."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags a serem aplicadas à IAM Policy."
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.tags) : !can(regex("^aws:", lower(k)))])
    error_message = "Chaves de tags não podem começar com 'aws:'."
  }
}
