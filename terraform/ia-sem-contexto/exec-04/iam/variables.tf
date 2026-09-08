variable "region" {
  description = "Região AWS onde os recursos serão gerenciados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    description   = "A região não pode ser vazia."
  }
}

variable "policy_name_prefix" {
  description = "Prefixo para o nome da IAM Policy. O provedor completará com um sufixo único."
  type        = string
  default     = "tf-managed-"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.policy_name_prefix))
    description   = "O prefixo deve usar apenas caracteres permitidos pela AWS: A-Za-z0-9+=,.@_- e ter até 64 caracteres."
  }
}

variable "path" {
  description = "Caminho (path) da IAM Policy. Deve começar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.path, "/") && endswith(var.path, "/")
    description   = "O path deve começar e terminar com '/'. Ex.: '/', '/service/', '/app/prod/'."
  }
}

variable "description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Managed IAM Policy criada por Terraform."
}

variable "statements" {
  description = "Lista de statements para compor o documento de policy IAM."
  type = list(object({
    sid        = optional(string)
    effect     = string
    actions    = set(string)
    resources  = set(string)
    conditions = optional(map(any), {})
  }))
  default = []

  validation {
    condition     = alltrue([for s in var.statements : contains(["Allow", "Deny"], s.effect)])
    description   = "Cada statement.effect deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.actions) > 0 && length(s.resources) > 0])
    description   = "Cada statement deve possuir ao menos uma action e um resource."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas à IAM Policy."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(trim(k)) > 0 && length(trim(v)) >= 0])
    description   = "Chaves de tags não podem ser vazias."
  }
}
