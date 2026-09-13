variable "aws_region" {
  type        = string
  description = "Regiao AWS onde a policy sera provisionada (IAM e global, mas o provider exige uma regiao valida)."
  default     = "us-east-1"
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy."

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e + = , . @ _ -)."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Managed by Terraform"
}

variable "path" {
  type        = string
  description = "Path da IAM Policy."
  default     = "/"
}

variable "policy_statements" {
  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))
  description = "Lista de statements da policy. Actions e resources devem ser explicitos; wildcard '*' isolado nao e permitido para reforcar o principio de menor privilegio."

  validation {
    condition     = length(var.policy_statements) > 0
    error_message = "Pelo menos um statement deve ser definido em policy_statements."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : !contains(s.actions, "*")
    ])
    error_message = "Wildcard '*' em actions nao e permitido. Especifique acoes explicitas (ex: s3:GetObject)."
  }

  validation {
    condition = alltrue([
      for s in var.policy_statements : !contains(s.resources, "*")
    ])
    error_message = "Wildcard '*' em resources nao e permitido. Especifique ARNs explicitos."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Policy."
  default     = {}
}
