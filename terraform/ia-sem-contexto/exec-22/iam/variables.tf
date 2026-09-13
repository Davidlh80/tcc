variable "aws_region" {
  type        = string
  description = "Regiao AWS onde o provider ira operar."
  default     = "us-east-1"
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy."
  default     = "example-iam-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy gerenciada via Terraform."
}

variable "path" {
  type        = string
  description = "Path da IAM Policy dentro da conta AWS."
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.path))
    error_message = "path deve iniciar e terminar com \"/\", por exemplo \"/\" ou \"/app/\"."
  }
}

variable "effect" {
  type        = string
  description = "Efeito da statement da policy (Allow ou Deny)."
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas pela policy. Wildcard total (\"*\") nao e permitido."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions deve conter ao menos uma acao e nao pode incluir o wildcard total \"*\"."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Wildcard total (\"*\") nao e permitido."
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "*")
    error_message = "allowed_resources deve conter ao menos um ARN e nao pode incluir o wildcard total \"*\"."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Policy."
  default     = {}
}
