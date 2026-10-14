variable "policy_name" {
  description = "Nome-base da policy."
  type        = string

  validation {
    condition = (
      length(var.policy_name) > 0 &&
      can(regex("^[A-Za-z0-9+=,.@_-]+$", var.policy_name))
    )
    error_message = "Informe um nome-base valido para a policy."
  }
}

variable "role_name" {
  description = "Nome-base da role."
  type        = string

  validation {
    condition = (
      length(var.role_name) > 0 &&
      can(regex("^[A-Za-z0-9+=,.@_-]+$", var.role_name))
    )
    error_message = "Informe um nome-base valido para a role."
  }
}

variable "environment" {
  description = "Ambiente de implantacao."
  type        = string

  validation {
    condition = contains(
      ["dev", "hml", "stg", "prod"],
      var.environment
    )
    error_message = "Use dev, hml, stg ou prod."
  }
}

variable "trusted_principal_type" {
  description = "Tipo do principal: Service, AWS ou Federated."
  type        = string
  default     = "Service"

  validation {
    condition = contains(
      ["Service", "AWS", "Federated"],
      var.trusted_principal_type
    )
    error_message = "Tipo de principal invalido."
  }
}

variable "trusted_principal_identifiers" {
  description = "Identificadores explicitos dos principals autorizados."
  type        = list(string)

  validation {
    condition = (
      length(var.trusted_principal_identifiers) > 0 &&
      alltrue([
        for principal in var.trusted_principal_identifiers :
        trimspace(principal) != "" &&
        !strcontains(principal, "*")
      ])
    )
    error_message = "Informe principals explicitos sem curingas."
  }
}

variable "allowed_actions" {
  description = "Acoes IAM explicitas permitidas."
  type        = list(string)

  validation {
    condition = (
      length(var.allowed_actions) > 0 &&
      alltrue([
        for action in var.allowed_actions :
        trimspace(action) != "" &&
        !strcontains(action, "*")
      ])
    )
    error_message = "Informe acoes explicitas sem curingas."
  }
}

variable "allowed_resources" {
  description = "ARNs dos recursos autorizados."
  type        = list(string)

  validation {
    condition = (
      length(var.allowed_resources) > 0 &&
      alltrue([
        for resource in var.allowed_resources :
        trimspace(resource) != "" &&
        resource != "*"
      ])
    )
    error_message = "Informe ARNs especificos; Resource = '*' nao e permitido."
  }
}

variable "max_session_duration" {
  description = "Duracao maxima da sessao da role, em segundos."
  type        = number
  default     = 3600

  validation {
    condition = (
      var.max_session_duration >= 3600 &&
      var.max_session_duration <= 43200
    )
    error_message = "A duracao deve estar entre 3600 e 43200 segundos."
  }
}

variable "additional_tags" {
  description = "Tags adicionais. As tags obrigatorias nao podem ser sobrescritas."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.additional_tags :
      trimspace(key) != "" &&
      trimspace(value) != "" &&
      !contains(
        ["Environment", "ManagedBy", "Component"],
        key
      )
    ])
    error_message = "Tags vazias ou tentativa de sobrescrever tags obrigatorias."
  }
}
