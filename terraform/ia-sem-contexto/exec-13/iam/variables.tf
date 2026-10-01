variable "aws_region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."
  default     = "app-role"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,64}$", var.role_name))
    error_message = "role_name deve ter entre 1 e 64 caracteres validos para nomes de IAM Role (letras, numeros e + = , . @ -)."
  }
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "Role gerenciada via Terraform, com politica de permissoes minimizada anexada."
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada a role."
  default     = "app-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve ter entre 1 e 128 caracteres validos para nomes de IAM Policy (letras, numeros e + = , . @ -)."
  }
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy gerenciada via Terraform com permissoes escopadas a acoes e recursos especificos."
}

variable "path" {
  type        = string
  description = "Path IAM aplicado a role e a policy."
  default     = "/"

  validation {
    condition     = can(regex("^/", var.path)) && can(regex("/$", var.path))
    error_message = "path deve comecar e terminar com \"/\"."
  }
}

variable "trusted_service_principals" {
  type        = list(string)
  description = "Lista de service principals da AWS (ex.: ec2.amazonaws.com) autorizados a assumir a role via sts:AssumeRole."
  default     = ["ec2.amazonaws.com"]
}

variable "trusted_account_arns" {
  type        = list(string)
  description = "Lista de ARNs de contas/roles/usuarios AWS autorizados a assumir a role via sts:AssumeRole (cenario cross-account)."
  default     = []
}

variable "external_id" {
  type        = string
  description = "External ID exigido na condicao sts:ExternalId quando trusted_account_arns for utilizado. Deixe vazio para nao aplicar a condicao."
  default     = ""
  sensitive   = true
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima da sessao assumida (em segundos)."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN de uma policy existente a ser usada como permissions boundary da role. Deixe vazio para nao aplicar boundary."
  default     = ""
}

variable "force_detach_policies" {
  type        = bool
  description = "Se true, permite que o Terraform desanexe policies da role automaticamente antes de destrui-la."
  default     = false
}

variable "policy_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas pela policy. Wildcard \"*\" nao e permitido."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions deve conter ao menos uma acao e nao pode incluir o wildcard \"*\"."
  }
}

variable "policy_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos permitidos pela policy. Wildcard \"*\" nao e permitido."
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0 && !contains(var.policy_resources, "*")
    error_message = "policy_resources deve conter ao menos um ARN e nao pode incluir o wildcard \"*\"."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas a role e a policy."
  default     = {}
}
