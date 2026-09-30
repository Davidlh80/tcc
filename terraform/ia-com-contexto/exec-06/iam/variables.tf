variable "environment" {
  description = "Ambiente de implantacao do recurso"
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  description = "Nome do sistema/projeto ao qual o recurso pertence"
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados"
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias do padrao organizacional"
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy/Role, usada na composicao do nome padronizado (ex.: readonly, deploy)"
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descricao aplicada a IAM Policy e a IAM Role"
  type        = string
  default     = "Policy e role gerenciadas via Terraform"
}

variable "allowed_actions" {
  description = "Lista de acoes IAM permitidas (Effect Allow) na policy anexada a role"
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao IAM."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos permitidos (Effect Allow) na policy anexada a role"
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um ARN de recurso."
  }
}

variable "trusted_principal_arns" {
  description = "Lista de ARNs de principals (contas, roles ou usuarios IAM) autorizados a assumir a role via trust policy"
  type        = list(string)

  validation {
    condition     = length(var.trusted_principal_arns) > 0
    error_message = "trusted_principal_arns deve conter ao menos um principal ARN."
  }

  validation {
    condition     = !contains(var.trusted_principal_arns, "*")
    error_message = "trusted_principal_arns nao pode conter o curinga '*'."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, da sessao assumida pela role"
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}
