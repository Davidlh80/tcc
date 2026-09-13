variable "region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Nome da IAM Policy. Deve ser unico dentro da conta AWS."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "O nome da policy deve ter entre 1 e 128 caracteres."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed by Terraform"
}

variable "path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}

variable "policy_statements" {
  description = "Lista de statements do documento de policy. Cada item define sid (opcional), effect (Allow ou Deny), actions e resources. Evite o uso de wildcard '*' em actions e resources; prefira ARNs e acoes especificas."
  type = list(object({
    sid       = optional(string)
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "AllowReadOwnS3Objects"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
    }
  ]

  validation {
    condition     = length(var.policy_statements) > 0
    error_message = "Ao menos um statement deve ser fornecido em policy_statements."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo 'effect' de cada statement deve ser 'Allow' ou 'Deny'."
  }

  validation {
    condition     = alltrue([for s in var.policy_statements : !contains(s.actions, "*")])
    error_message = "Wildcard '*' nao e permitido em actions. Especifique as acoes necessarias."
  }
}
