variable "aws_region" {
  description = "Região AWS a ser utilizada pelo provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "A região deve seguir o padrão ex: us-east-1, eu-west-1, sa-east-1."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy gerenciada pelo cliente."
  type        = string
  default     = "custom-iam-policy"
  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "O nome deve ter de 1 a 128 caracteres e pode conter letras, números e os caracteres: +=,.@_-"
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Managed by Terraform - Customer managed policy."
}

variable "policy_path" {
  description = "Caminho (path) da policy. Deve ser '/' ou começar e terminar com '/'."
  type        = string
  default     = "/"
  validation {
    condition     = var.policy_path == "/" || can(regex("^/.+/$", var.policy_path))
    error_message = "O path deve ser '/' ou iniciar e terminar com '/'. Ex.: '/', '/service-role/', '/teamA/'."
  }
}

variable "policy_statements" {
  description = "Lista de statements da policy. Quando vazio, uma política mínima de leitura de identidade (sts:GetCallerIdentity) será criada por padrão."
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
    condition = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))
  default = []

  validation {
    condition = length(var.policy_statements) == 0 || alltrue([
      for s in var.policy_statements :
      contains(["Allow", "Deny"], s.effect) && length(s.actions) > 0 && length(s.resources) > 0
    ])
    error_message = "Cada statement deve ter effect 'Allow' ou 'Deny' e listas não vazias para actions e resources."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas à policy e propagadas via default_tags do provider."
  type        = map(string)
  default     = {}
}
