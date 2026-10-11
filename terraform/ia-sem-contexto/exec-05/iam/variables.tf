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
  default     = "Role gerenciada via Terraform."
}

variable "max_session_duration" {
  description = "Duracao maxima da sessao assumida, em segundos (entre 3600 e 43200)."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals (contas, roles ou usuarios IAM) autorizados a assumir esta role. Nao pode estar vazia nem conter o wildcard '*'."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0 && !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns deve conter ao menos um ARN valido e nao pode incluir o wildcard '*'."
  }
}

variable "require_external_id" {
  description = "Se verdadeiro, adiciona uma condicao de ExternalId na trust policy para mitigar o problema de confused deputy."
  type        = bool
  default     = false
}

variable "external_id" {
  description = "Valor de ExternalId exigido na trust policy quando require_external_id = true."
  type        = string
  default     = ""
  sensitive   = true
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
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
  default     = "Policy gerenciada via Terraform."
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas pela policy. Nao pode estar vazia nem conter o wildcard '*'."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "*")
    error_message = "allowed_actions nao pode ser vazio nem conter o wildcard '*'."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as actions da policy se aplicam. Evite o wildcard '*' sempre que possivel."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN."
  }
}

variable "tags" {
  description = "Tags aplicadas aos recursos IAM suportados (role e policy)."
  type        = map(string)
  default     = {}
}
