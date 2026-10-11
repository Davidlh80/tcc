variable "aws_region" {
  type        = string
  description = "Regiao AWS onde os recursos IAM serao gerenciados (IAM e global, mas o provider exige uma regiao)."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."
  default     = "example-restricted-role"
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "Role de exemplo com trust policy restrita e permissoes minimas."
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada a role."
  default     = "example-least-privilege-policy"
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy de exemplo com permissoes restritas a actions e recursos especificos."
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) da sessao assumida via esta role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal (conta root, usuario ou role) autorizado a assumir esta role via sts:AssumeRole. Nao pode ser '*' nem um ARN que represente qualquer conta."
  default     = "arn:aws:iam::123456789012:role/example-trusted-role"

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(root|user/.+|role/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM valido (root, user/... ou role/...) de uma conta especifica, e nao pode ser '*'."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de IAM actions permitidas na policy anexada a role. Nao pode conter o wildcard total '*' nem acoes administrativas amplas como 'iam:*'."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*") && !contains(var.allowed_actions, "iam:*")
    error_message = "allowed_actions deve conter ao menos uma action especifica e nao pode incluir '*' ou 'iam:*'."
  }
}

variable "resource_arns" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as allowed_actions se aplicam. Nao pode conter o wildcard total '*'."
  default     = ["arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.resource_arns) > 0 && !contains(var.resource_arns, "*")
    error_message = "resource_arns deve conter ao menos um ARN especifico e nao pode incluir o wildcard '*'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a IAM Role e a IAM Policy."
  default = {
    ManagedBy = "terraform"
  }
}
