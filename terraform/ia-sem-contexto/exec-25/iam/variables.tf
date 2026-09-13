variable "aws_region" {
  type        = string
  description = "Regiao AWS onde o provider sera configurado."
  default     = "us-east-1"
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy."
  default     = "custom-iam-policy"
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "IAM policy gerenciada via Terraform com escopo restrito por padrao."
}

variable "policy_path" {
  type        = string
  description = "Path da IAM Policy dentro do IAM."
  default     = "/"
}

variable "effect" {
  type        = string
  description = "Efeito da statement da policy (Allow ou Deny)."
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "O valor de effect deve ser \"Allow\" ou \"Deny\"."
  }
}

variable "actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas ou negadas pela policy. Evite usar wildcard amplo (\"*\") em ambientes produtivos."
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.actions) > 0
    error_message = "A lista de actions nao pode ser vazia."
  }
}

variable "resources" {
  type        = list(string)
  description = "Lista de ARNs sobre os quais a policy se aplica. Substitua o valor padrao pelo ARN real do recurso alvo."
  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*",
  ]

  validation {
    condition     = length(var.resources) > 0
    error_message = "A lista de resources nao pode ser vazia."
  }
}

variable "conditions" {
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  description = "Lista opcional de condicoes IAM (test, variable, values) aplicadas a statement da policy."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Policy."
  default = {
    ManagedBy = "terraform"
  }
}
