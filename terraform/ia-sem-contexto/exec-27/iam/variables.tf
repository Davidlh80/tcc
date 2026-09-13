variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-restricted-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }

  validation {
    condition     = can(regex("^[\\w+=,.@-]+$", var.policy_name))
    error_message = "policy_name contem caracteres invalidos para um nome de IAM Policy."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM Policy gerada com escopo minimo, sem wildcards em actions ou resources."
}

variable "path" {
  description = "Path da IAM Policy no IAM."
  type        = string
  default     = "/"
}

variable "effect" {
  description = "Efeito da statement da policy (Allow ou Deny)."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "actions" {
  description = "Lista de actions IAM permitidas ou negadas pela policy. Wildcard \"*\" nao e permitido por padrao de seguranca."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.actions) > 0
    error_message = "actions deve conter pelo menos um item."
  }

  validation {
    condition     = !contains(var.actions, "*")
    error_message = "Uso de wildcard \"*\" em actions nao e permitido. Especifique as actions necessarias."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Wildcard \"*\" nao e permitido por padrao de seguranca."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.resources) > 0
    error_message = "resources deve conter pelo menos um item."
  }

  validation {
    condition     = !contains(var.resources, "*")
    error_message = "Uso de wildcard \"*\" em resources nao e permitido. Especifique os ARNs necessarios."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
