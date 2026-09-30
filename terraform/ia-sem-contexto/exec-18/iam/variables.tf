variable "aws_region" {
  type        = string
  description = "Regiao AWS onde os recursos serao provisionados."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Nome base usado para compor os nomes da IAM Role e da IAM Policy (sufixos -role/-policy sao adicionados automaticamente)."
  default     = "app"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,100}$", var.name))
    error_message = "O nome deve conter apenas caracteres validos para IAM (letras, numeros, + = , . @ _ -) e ter entre 1 e 100 caracteres."
  }
}

variable "iam_path" {
  type        = string
  description = "Path da IAM Role e da IAM Policy."
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.iam_path))
    error_message = "O path deve comecar e terminar com '/'."
  }
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "IAM Role gerenciada via Terraform."
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "IAM Policy gerenciada via Terraform, anexada a uma IAM Role."
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima da sessao assumida (em segundos). Deve estar entre 3600 e 43200."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "ARN de uma policy a ser usada como permissions boundary da role. Deixe null para nao aplicar boundary."
  default     = null
}

variable "trusted_service_principals" {
  type        = list(string)
  description = "Lista de service principals AWS (ex: ec2.amazonaws.com) autorizados a assumir a role."
  default     = ["ec2.amazonaws.com"]
}

variable "trusted_aws_principals" {
  type        = list(string)
  description = "Lista de ARNs de contas/usuarios/roles AWS autorizados a assumir a role."
  default     = []
}

variable "external_id" {
  type        = string
  description = "External ID exigido na assume role (recomendado para acesso cross-account de terceiros). Deixe null para nao exigir."
  default     = null
}

variable "require_mfa_for_aws_principals" {
  type        = bool
  description = "Se verdadeiro, exige MFA para principals do tipo AWS assumirem a role."
  default     = true
}

variable "policy_actions" {
  type        = list(string)
  description = "Lista de actions IAM permitidas pela policy. Evite wildcards amplos como '*'."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.policy_actions) > 0 && !contains(var.policy_actions, "*")
    error_message = "policy_actions nao pode ser vazio nem conter o wildcard total '*'."
  }
}

variable "policy_resources" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as actions se aplicam. Evite '*' irrestrito."
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.policy_resources) > 0 && !contains(var.policy_resources, "*")
    error_message = "policy_resources nao pode ser vazio nem conter o wildcard total '*'."
  }
}

variable "require_secure_transport" {
  type        = bool
  description = "Se verdadeiro, adiciona condicao exigindo aws:SecureTransport=true na policy."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas a IAM Role e a IAM Policy."
  default     = {}
}
