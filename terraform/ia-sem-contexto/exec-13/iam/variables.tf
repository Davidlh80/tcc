variable "aws_region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-iam-policy"

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
  description = "Path da IAM Policy."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "Lista de statements da policy. Cada statement deve seguir o principio de menor privilegio: evite effect = \"Allow\" combinado com actions ou resources igual a \"*\"."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "AllowReadOnlyLogsExample"
      effect    = "Allow"
      actions   = ["logs:DescribeLogGroups", "logs:DescribeLogStreams"]
      resources = ["arn:aws:logs:*:*:*"]
    }
  ]

  validation {
    condition     = length(var.statements) > 0
    error_message = "Deve haver ao menos um statement definido."
  }

  validation {
    condition     = alltrue([for s in var.statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo effect de cada statement deve ser \"Allow\" ou \"Deny\"."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.actions) > 0])
    error_message = "Cada statement deve conter ao menos uma action."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.resources) > 0])
    error_message = "Cada statement deve conter ao menos um resource."
  }
}
