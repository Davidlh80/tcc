variable "aws_region" {
  description = "Regiao AWS usada pelo provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region deve estar no formato valido, por exemplo: us-east-1, eu-west-1."
  }
}

variable "name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "ro-viewer"

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 128 && can(regex("^[A-Za-z0-9+=,.@_-]+$", var.name))
    error_message = "O nome deve ter entre 1 e 128 caracteres e conter apenas A-Za-z0-9+=,.@_-"
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Read-only access to common AWS services."
}

variable "path" {
  description = "Caminho (path) da IAM Policy."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.path, "/") && endswith(var.path, "/") && length(var.path) <= 512
    error_message = "path deve iniciar e terminar com / e ter no maximo 512 caracteres."
  }
}

variable "statements" {
  description = "Lista de statements que compoem a IAM Policy."
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      effect    = "Allow"
      actions   = ["ec2:Describe*"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["s3:Get*", "s3:List*"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["iam:Get*", "iam:List*"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["cloudwatch:Get*", "cloudwatch:List*"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["logs:Describe*", "logs:Get*", "logs:List*"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["rds:Describe*"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["lambda:Get*", "lambda:List*"]
      resources = ["*"]
    }
  ]

  validation {
    condition = length(var.statements) > 0 && alltrue([
      for s in var.statements :
      contains(["ALLOW", "DENY"], upper(s.effect)) &&
      length(s.actions) > 0 &&
      length(s.resources) > 0
    ])
    error_message = "Cada statement deve ter effect Allow ou Deny e pelo menos uma action e um resource."
  }
}

variable "tags" {
  description = "Tags aplicadas ao recurso da IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }

  validation {
    condition     = alltrue([for k, v in var.tags : length(trim(k)) > 0 && length(trim(v)) > 0])
    error_message = "Chaves e valores de tags devem ser strings nao vazias."
  }
}
