variable "aws_region" {
  description = "Região AWS onde o provider será configurado."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-least-privilege-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "O nome da policy deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy IAM gerada via Terraform seguindo o principio de menor privilegio."
}

variable "path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "effect" {
  description = "Efeito da statement da policy (Allow ou Deny)."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "O valor de effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas pela policy. Wildcard total (\"*\") nao e permitido."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "Informe pelo menos uma action em allowed_actions."
  }

  validation {
    condition     = alltrue([for a in var.allowed_actions : a != "*"])
    error_message = "Actions com wildcard total (\"*\") nao sao permitidas. Especifique actions granulares."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Wildcard total (\"*\") nao e permitido."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "Informe pelo menos um recurso em allowed_resources."
  }

  validation {
    condition     = alltrue([for r in var.allowed_resources : r != "*"])
    error_message = "Recursos com wildcard total (\"*\") nao sao permitidos. Especifique ARNs concretos."
  }
}

variable "enforce_secure_transport" {
  description = "Se true, adiciona condicao exigindo aws:SecureTransport=true na statement."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Policy."
  type        = map(string)
  default     = {}
}
