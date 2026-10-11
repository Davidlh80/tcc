variable "aws_region" {
  description = "Regiao AWS usada pelo provider e para montar ARNs de recursos regionais."
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Nome da IAM Role a ser criada."
  type        = string
  default     = "example-scoped-role"
}

variable "role_description" {
  description = "Descricao da IAM Role."
  type        = string
  default     = "Role de exemplo com permissoes minimas e trust policy restrita."
}

variable "max_session_duration" {
  description = "Duracao maxima (em segundos) de uma sessao assumida da role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 900 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 900 e 43200 segundos."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada e anexada a role."
  type        = string
  default     = "example-scoped-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy de exemplo com acoes e recursos restritos (sem permissoes administrativas)."
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principais (contas, roles ou usuarios) autorizados a assumir a role. Nao pode conter \"*\" nem ficar vazia."
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0 && !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns deve conter ao menos um ARN valido e nao pode conter o valor \"*\"."
  }
}

variable "assume_role_external_id" {
  description = "ExternalId opcional exigido na trust policy para mitigar o problema do 'confused deputy'. Use null para nao exigir ExternalId."
  type        = string
  default     = null
  nullable    = true
}

variable "cloudwatch_log_group_name_prefix" {
  description = "Prefixo de nome dos log groups do CloudWatch Logs aos quais a role tera permissao de escrita."
  type        = string
  default     = "/example-app/"
}

variable "tags" {
  description = "Tags aplicadas a role e a policy criadas."
  type        = map(string)
  default     = {}
}
