variable "aws_region" {
  description = "Regiao AWS onde os recursos IAM serao provisionados (IAM e global, mas o provider exige uma regiao)."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region deve seguir o padrao de regiao AWS, ex: us-east-1."
  }
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "app-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64 && can(regex("^[\\w+=,.@-]+$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM (letras, numeros e + = , . @ -)."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM Role gerenciada via Terraform."
}

variable "policy_name" {
  description = "Nome da IAM Policy que sera anexada a Role."
  type        = string
  default     = "app-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128 && can(regex("^[\\w+=,.@-]+$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM (letras, numeros e + = , . @ -)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM Policy gerenciada via Terraform, anexada a uma IAM Role."
}

variable "path" {
  description = "Path IAM aplicado a Role e a Policy."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/$|^/.*/$", var.path))
    error_message = "path deve comecar e terminar com \"/\", ex: \"/\" ou \"/apps/\"."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida da Role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "force_detach_policies" {
  description = "Se true, forca o desanexamento de policies ao destruir a Role."
  type        = bool
  default     = true
}

variable "permissions_boundary_arn" {
  description = "ARN de uma policy a ser usada como permissions boundary da Role. Deixe null para nao aplicar boundary."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.permissions_boundary_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:policy/.+$", var.permissions_boundary_arn))
    error_message = "permissions_boundary_arn deve ser null ou um ARN valido de IAM policy."
  }
}

variable "trusted_principal_type" {
  description = "Tipo do principal confiavel na trust policy da Role (Service, AWS ou Federated)."
  type        = string
  default     = "Service"

  validation {
    condition     = contains(["Service", "AWS", "Federated"], var.trusted_principal_type)
    error_message = "trusted_principal_type deve ser \"Service\", \"AWS\" ou \"Federated\"."
  }
}

variable "trusted_principal_identifiers" {
  description = "Lista de identificadores do principal confiavel (ex: [\"ec2.amazonaws.com\"] ou [\"arn:aws:iam::123456789012:root\"])."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = length(var.trusted_principal_identifiers) > 0
    error_message = "trusted_principal_identifiers nao pode ser uma lista vazia."
  }
}

variable "external_id" {
  description = "External ID exigido na assume role (recomendado para principals do tipo AWS/cross-account). Deixe null para nao exigir."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.external_id == null || (length(var.external_id) >= 2 && length(var.external_id) <= 1224)
    error_message = "external_id deve ser null ou ter entre 2 e 1224 caracteres."
  }
}

variable "policy_statements" {
  description = "Lista de statements da IAM Policy. Nao possui default para forcar a definicao explicita de permissoes minimas necessarias."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))

  validation {
    condition     = length(var.policy_statements) > 0
    error_message = "Defina ao menos uma statement em policy_statements."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)
    ])
    error_message = "O campo effect de cada statement deve ser \"Allow\" ou \"Deny\"."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : !(contains(s.actions, "*") && contains(s.resources, "*"))
    ])
    error_message = "Nao e permitido combinar actions = [\"*\"] com resources = [\"*\"] na mesma statement (viola o principio de menor privilegio)."
  }
}

variable "additional_managed_policy_arns" {
  description = "ARNs adicionais de managed policies da AWS a serem anexadas a Role, alem da policy gerenciada por este modulo."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags adicionais aplicadas a Role e a Policy."
  type        = map(string)
  default     = {}
}
