variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "restricted-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "IAM Role com permissoes restritas, criada via Terraform."
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via sts:AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arn" {
  description = "ARN do principal (usuario, role ou conta) autorizado a assumir esta role. Nao pode ser um wildcard."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && length(regexall("\\*", var.trusted_principal_arn)) == 0
    error_message = "trusted_principal_arn nao pode ser \"*\" nem conter wildcards. Informe um ARN especifico (ex.: arn:aws:iam::123456789012:role/nome-da-role)."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string
  default     = "restricted-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "IAM Policy com permissoes de minimo privilegio, criada via Terraform."
}

variable "policy_actions" {
  description = "Lista de actions permitidas pela policy. Wildcards amplos (\"*\") nao sao permitidos."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = alltrue([for action in var.policy_actions : action != "*"])
    error_message = "Nenhuma action pode ser \"*\". Especifique actions concretas (ex.: s3:GetObject)."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Wildcard total (\"*\") nao e permitido."
  type        = list(string)

  validation {
    condition     = alltrue([for resource_arn in var.policy_resources : resource_arn != "*"])
    error_message = "Nenhum resource pode ser \"*\". Especifique ARNs concretos (ex.: arn:aws:s3:::meu-bucket/*)."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Role e na IAM Policy."
  type        = map(string)
  default     = {}
}
