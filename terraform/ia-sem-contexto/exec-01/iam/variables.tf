variable "aws_region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "app-least-privilege-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerada com escopo restrito de acoes e recursos."
}

variable "policy_path" {
  description = "Path da IAM Policy dentro da conta AWS."
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
  description = "Lista de acoes IAM permitidas/negadas pela policy. Evite wildcards amplos (ex: \"*\") em ambientes produtivos."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.actions) > 0
    error_message = "actions nao pode ser uma lista vazia."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Evite \"*\" para manter o principio de menor privilegio."
  type        = list(string)
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.resources) > 0
    error_message = "resources nao pode ser uma lista vazia."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
