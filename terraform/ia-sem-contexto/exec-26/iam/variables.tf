variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefixo usado para nomear a role e a policy (deve iniciar com letra, apenas letras, numeros e hifen)."
  type        = string
  default     = "app"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,30}$", var.name_prefix))
    error_message = "name_prefix deve iniciar com uma letra e conter apenas letras, numeros e hifen (2 a 31 caracteres)."
  }
}

variable "trusted_service_principals" {
  description = "Servicos AWS autorizados a assumir a role (ex.: ec2.amazonaws.com, lambda.amazonaws.com). Deixe vazio se usar apenas trusted_account_arns."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]

  validation {
    condition     = alltrue([for p in var.trusted_service_principals : can(regex("\\.amazonaws\\.com$", p))])
    error_message = "Cada principal de servico deve ser um endpoint valido terminado em '.amazonaws.com'."
  }
}

variable "trusted_account_arns" {
  description = "ARNs de contas, roles ou usuarios IAM autorizados a assumir a role via sts:AssumeRole (uso opcional para cenarios cross-account)."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for a in var.trusted_account_arns : can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:", a))])
    error_message = "Cada item de trusted_account_arns deve ser um ARN IAM valido (ex.: arn:aws:iam::123456789012:role/nome)."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na condicao sts:ExternalId ao assumir a role via trusted_account_arns. Recomendado para acesso cross-account."
  type        = string
  default     = ""
  sensitive   = true
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, de uma sessao assumida da role (entre 3600 e 43200)."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  description = "ARN opcional de uma policy a ser usada como permissions boundary da role."
  type        = string
  default     = null
}

variable "policy_actions" {
  description = "Lista de actions IAM permitidas pela policy. Wildcard '*' nao e permitido por padrao de seguranca."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions deve conter ao menos uma action explicita e nao pode incluir o wildcard '*'."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Wildcard '*' nao e permitido por padrao de seguranca."
  type        = list(string)
  default     = ["arn:aws:s3:::example-app-bucket", "arn:aws:s3:::example-app-bucket/*"]

  validation {
    condition     = alltrue([for r in var.policy_resources : can(regex("^arn:", r)) && r != "*"])
    error_message = "Cada item de policy_resources deve ser um ARN valido (iniciando com 'arn:') e nao pode ser o wildcard '*'."
  }
}

variable "tags" {
  description = "Tags aplicadas aos recursos IAM criados."
  type        = map(string)
  default     = {}
}
