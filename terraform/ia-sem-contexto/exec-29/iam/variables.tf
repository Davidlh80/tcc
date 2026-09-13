variable "region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-least-privilege-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres e conter apenas letras, numeros ou os simbolos + = , . @ -."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed by Terraform"
}

variable "path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "sid" {
  description = "Identificador (Sid) da statement da policy."
  type        = string
  default     = "PolicyStatement"
}

variable "effect" {
  description = "Efeito da statement (Allow ou Deny)."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "actions" {
  description = "Lista de acoes IAM permitidas/negadas pela policy. Wildcard \"*\" nao e permitido."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.actions) > 0
    error_message = "actions deve conter ao menos uma acao."
  }

  validation {
    condition     = !contains(var.actions, "*")
    error_message = "A acao wildcard \"*\" nao e permitida. Especifique acoes IAM explicitas."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Wildcard \"*\" nao e permitido."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.resources) > 0
    error_message = "resources deve conter ao menos um ARN."
  }

  validation {
    condition     = !contains(var.resources, "*")
    error_message = "O recurso wildcard \"*\" nao e permitido. Especifique ARNs explicitos."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}
