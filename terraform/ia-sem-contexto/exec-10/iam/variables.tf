variable "policy_name" {
  description = "Nome da IAM Policy. Deve seguir o padrao de nomenclatura aceito pela AWS (ate 128 caracteres, apenas alfanumericos e os simbolos _+=,.@-)."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres e conter apenas letras, numeros e os simbolos _ + = , . @ -."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Gerenciada via Terraform."

  validation {
    condition     = length(var.policy_description) <= 1000
    error_message = "policy_description deve ter no maximo 1000 caracteres."
  }
}

variable "policy_path" {
  description = "Path da IAM Policy. Deve comecar e terminar com '/'."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/([\\w+=,.@-]+/)*$", var.policy_path))
    error_message = "policy_path deve comecar e terminar com '/' (ex: '/' ou '/time-plataforma/')."
  }
}

variable "statements" {
  description = "Lista de statements da IAM Policy. Cada statement exige actions e resources explicitos (o uso de '*' irrestrito nao e permitido por padrao de seguranca)."
  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))

  validation {
    condition     = length(var.statements) > 0
    error_message = "Pelo menos um statement deve ser definido em var.statements."
  }

  validation {
    condition = alltrue([
      for s in var.statements : contains(["Allow", "Deny"], s.effect)
    ])
    error_message = "O campo effect de cada statement deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition = alltrue([
      for s in var.statements : length(s.actions) > 0
    ])
    error_message = "Cada statement deve declarar ao menos uma action explicita."
  }

  validation {
    condition = alltrue([
      for s in var.statements : length(s.resources) > 0
    ])
    error_message = "Cada statement deve declarar ao menos um resource explicito."
  }

  validation {
    condition = alltrue([
      for s in var.statements : !contains(s.actions, "*")
    ])
    error_message = "O uso de '*' irrestrito em actions nao e permitido. Use acoes explicitas ou prefixos de servico (ex: 's3:Get*')."
  }

  validation {
    condition = alltrue([
      for s in var.statements : !contains(s.resources, "*")
    ])
    error_message = "O uso de '*' irrestrito em resources nao e permitido. Especifique ARNs explicitos."
  }
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
