variable "aws_region" {
  description = "Regiao AWS onde os recursos IAM serao criados (IAM e global, mas o provider exige uma regiao)."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "app-execution-role"

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "role_name deve ter entre 1 e 64 caracteres."
  }
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role gerenciada via Terraform com policy customizada anexada."
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "app-execution-policy"

  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128
    error_message = "policy_name deve ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy de permissoes minimas necessarias para a role associada."
}

variable "trusted_principal_service" {
  description = "Principal de servico AWS (ex: ec2.amazonaws.com, lambda.amazonaws.com) autorizado a assumir a role via sts:AssumeRole."
  type        = string
  default     = "ec2.amazonaws.com"

  validation {
    condition     = can(regex("\\.amazonaws\\.com$", var.trusted_principal_service))
    error_message = "trusted_principal_service deve ser um principal de servico valido, terminando em '.amazonaws.com'."
  }
}

variable "external_id" {
  description = "External ID opcional exigido na condicao sts:ExternalId do trust policy, util para cenarios de assume role entre contas/terceiros. Deixe null para nao aplicar a condicao."
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) da sessao assumida via sts:AssumeRole."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 (1h) e 43200 (12h) segundos."
  }
}

variable "policy_actions" {
  description = "Lista de acoes IAM permitidas pela policy. Evite usar '*' em producao; prefira acoes explicitas de acordo com o principio de menor privilegio."
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  validation {
    condition     = length(var.policy_actions) > 0
    error_message = "policy_actions nao pode ser uma lista vazia."
  }
}

variable "policy_resources" {
  description = "Lista de ARNs de recursos aos quais as policy_actions se aplicam. Substitua o valor padrao pelos ARNs reais dos recursos."
  type        = list(string)
  default = [
    "arn:aws:s3:::REPLACE_WITH_BUCKET_NAME",
    "arn:aws:s3:::REPLACE_WITH_BUCKET_NAME/*",
  ]

  validation {
    condition     = length(var.policy_resources) > 0
    error_message = "policy_resources nao pode ser uma lista vazia."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas a IAM Role e a IAM Policy."
  type        = map(string)
  default     = {}
}
