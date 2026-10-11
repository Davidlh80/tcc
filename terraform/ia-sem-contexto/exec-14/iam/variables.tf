variable "aws_region" {
  description = "Regiao AWS utilizada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
}

variable "role_path" {
  description = "Path da IAM Role."
  type        = string
  default     = "/"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com permissoes restritas a um conjunto especifico de acoes e recursos."
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida por esta role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (conta, role ou usuario) autorizado a assumir esta role. Deve ser um ARN especifico; nao e permitido usar \"*\"."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:(iam|sts)::[0-9]{12}:.+$", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN valido no formato arn:aws:iam::<account-id>:<resource>, sem uso de wildcard."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
}

variable "policy_path" {
  description = "Path da IAM Policy."
  type        = string
  default     = "/"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com permissoes restritas, anexada a uma IAM Role especifica."
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas pela policy. Nao e permitido usar a action wildcard total \"*\"."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions deve conter ao menos uma action e nao pode incluir a action wildcard total \"*\"."
  }
}

variable "resource_arns" {
  description = "Lista de ARNs de recursos aos quais as actions da policy se aplicam. Nao e permitido usar o wildcard total \"*\"."
  type        = list(string)

  validation {
    condition     = length(var.resource_arns) > 0 && !contains(var.resource_arns, "*")
    error_message = "resource_arns deve conter ao menos um ARN e nao pode incluir o wildcard total \"*\"."
  }
}

variable "tags" {
  description = "Tags aplicadas a IAM Role e a IAM Policy, quando suportado."
  type        = map(string)
  default     = {}
}
