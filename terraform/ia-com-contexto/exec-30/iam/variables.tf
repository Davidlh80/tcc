variable "environment" {
  description = "Ambiente de implantacao do recurso. Deve ser um dos ambientes permitidos pela organizacao: dev, hml ou prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de 'environment' deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema ou aplicacao proprietaria do recurso, usado na composicao do nome padronizado."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de 'system' nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos (data sources/provider) serao avaliados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas as tags obrigatorias definidas pela organizacao."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade/nome da policy e da role associada, usado na composicao do nome padronizado (ex.: 'readonly', 'logging-access')."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de 'policy_name' nao pode ser vazio."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal autorizado a assumir a IAM Role (trust policy). Nao pode ser um wildcard '*'."
  type        = string

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws:(iam|sts)::\\d{12}:", var.trusted_principal_arn))
    error_message = "O valor de 'trusted_principal_arn' deve ser um ARN valido (conta, role ou usuario especifico) e nao pode ser '*'."
  }
}

variable "allowed_actions" {
  description = "Lista de IAM Actions permitidas na policy (Effect: Allow). Nao pode ser combinada com 'allowed_resources' contendo '*' simultaneamente a '*' nesta lista."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "O valor de 'allowed_actions' deve conter pelo menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs/recursos permitidos na policy (Effect: Allow). Nao pode ser combinada com 'allowed_actions' contendo '*' simultaneamente a '*' nesta lista."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "O valor de 'allowed_resources' deve conter pelo menos um recurso."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima, em segundos, da sessao assumida pela IAM Role."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "O valor de 'max_session_duration' deve estar entre 3600 e 43200 segundos."
  }
}
