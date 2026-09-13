variable "aws_region" {
  description = "Região AWS onde o provider será configurado."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy. Deve seguir o padrão aceito pela AWS (letras, números e os caracteres + = , . @ _ -)."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres válidos para nomes de IAM Policy (letras, números, + = , . @ _ -)."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform. Revise o princípio de menor privilégio antes de aplicar."
}

variable "path" {
  description = "Caminho (path) da IAM Policy dentro da conta AWS."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags a serem aplicadas à IAM Policy."
  type        = map(string)
  default     = {}
}

variable "statements" {
  description = "Lista de statements da policy (formato similar ao IAM Policy Document). Cada statement deve seguir o princípio de menor privilégio."
  type = list(object({
    sid       = optional(string)
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid    = "AllowReadOnlyS3Access"
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:ListBucket",
      ]
      resources = [
        "arn:aws:s3:::REPLACE_ME_BUCKET_NAME",
        "arn:aws:s3:::REPLACE_ME_BUCKET_NAME/*",
      ]
    }
  ]

  validation {
    condition     = alltrue([for s in var.statements : contains(["Allow", "Deny"], s.effect)])
    error_message = "O campo 'effect' de cada statement deve ser exatamente \"Allow\" ou \"Deny\"."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.actions) > 0])
    error_message = "Cada statement deve conter ao menos uma action."
  }

  validation {
    condition     = alltrue([for s in var.statements : length(s.resources) > 0])
    error_message = "Cada statement deve conter ao menos um resource."
  }

  validation {
    condition     = alltrue([for s in var.statements : !(contains(s.actions, "*") && contains(s.resources, "*"))])
    error_message = "Não é permitido combinar actions=[\"*\"] com resources=[\"*\"] em um mesmo statement (privilégio administrativo total)."
  }
}
