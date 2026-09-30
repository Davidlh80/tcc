variable "aws_region" {
  type        = string
  description = "Regiao AWS onde os recursos IAM serao provisionados (IAM e global, mas o provider exige uma regiao)."
  default     = "us-east-1"
}

variable "name_prefix" {
  type        = string
  description = "Prefixo usado para nomear a role e a policy (ex.: app-backend)."
  default     = "app"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,32}$", var.name_prefix))
    error_message = "name_prefix deve conter de 1 a 32 caracteres validos para nomes IAM (letras, numeros e + = , . @ _ -)."
  }
}

variable "path" {
  type        = string
  description = "Path IAM aplicado a role e a policy."
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.path))
    error_message = "path deve iniciar e terminar com \"/\", por exemplo \"/\" ou \"/app/\"."
  }
}

variable "trusted_service_principals" {
  type        = list(string)
  description = "Lista de service principals AWS (ex.: ec2.amazonaws.com) autorizados a assumir a role. Vazio por padrao para forcar escolha explicita quando nao usado com trusted_principal_arns."
  default     = ["ec2.amazonaws.com"]
}

variable "trusted_principal_arns" {
  type        = list(string)
  description = "Lista de ARNs de contas/roles/usuarios AWS autorizados a assumir a role via sts:AssumeRole."
  default     = []
}

variable "external_id" {
  type        = string
  description = "External ID opcional exigido na condicao sts:ExternalId ao assumir a role (recomendado para acesso cross-account de terceiros)."
  default     = ""
  sensitive   = true
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

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN opcional de uma policy usada como permissions boundary da role."
  default     = null
}

variable "policy_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas pela policy anexada a role. O uso do wildcard total \"*\" nao e permitido por padrao de seguranca."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions deve conter ao menos uma action e nao pode incluir o wildcard total \"*\"."
  }
}

variable "policy_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as policy_actions se aplicam. O uso do wildcard total \"*\" nao e permitido por padrao de seguranca."
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0 && !contains(var.policy_resources, "*")
    error_message = "policy_resources deve conter ao menos um ARN e nao pode ser o wildcard total \"*\"."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas a role e a policy."
  default     = {}
}
