variable "aws_region" {
  type        = string
  description = "Região AWS onde os recursos IAM serão provisionados (IAM é global, mas o provider exige uma região)."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."
  default     = "example-role"
}

variable "role_description" {
  type        = string
  description = "Descrição da IAM Role."
  default     = "Role de exemplo com permissoes escopadas e trust policy restrita."
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada à role."
  default     = "example-policy"
}

variable "policy_description" {
  type        = string
  description = "Descrição da IAM Policy."
  default     = "Policy de exemplo com permissoes minimas, sem wildcard amplo."
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do principal IAM (conta root, role ou user) autorizado a assumir esta role. Nao e permitido usar wildcard (\"*\")."

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:iam::[0-9]{12}:(root|(role|user)/.+)$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN IAM especifico (root, role ou user) e nao pode ser \"*\"."
  }
}

variable "external_id" {
  type        = string
  description = "ExternalId opcional exigido na assume role policy (condicao sts:ExternalId). Use null para desabilitar."
  default     = null
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) de uma sessao assumida da role."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "policy_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas pela policy. Nao pode ficar vazia nem conter wildcard amplo (\"*\")."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions nao pode ser vazio e nao pode conter o wildcard \"*\"."
  }
}

variable "policy_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Nao pode ficar vazia nem conter wildcard amplo (\"*\")."
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0 && !contains(var.policy_resources, "*")
    error_message = "policy_resources nao pode ser vazio e nao pode conter o wildcard \"*\"."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas aos recursos IAM suportados (role e policy)."
  default     = {}
}
