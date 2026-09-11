variable "environment" {
  description = "Ambiente alvo para provisionamento. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (ex.: tcc). Somente letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "A região deve estar no formato válido, por exemplo: us-east-1, sa-east-1, eu-west-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais para complementar as tags obrigatórias (as obrigatórias prevalecem em caso de conflito)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy (usada na composição do nome conforme padrão <environment>-<system>-iam-<policy_name>)."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM explicitamente permitidas (ex.: [\"s3:GetObject\", \"ec2:DescribeInstances\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : length(a) > 0])
    error_message = "allowed_actions deve conter ao menos uma ação válida e não pode incluir strings vazias."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos explicitamente permitidos (pode incluir curingas específicos por serviço; não combine Resource \"*\" com Action \"*\" na mesma statement)."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : length(r) > 0])
    error_message = "allowed_resources deve conter ao menos um recurso válido e não pode incluir strings vazias."
  }
}

variable "policy_description" {
  description = "Descrição opcional da IAM Policy."
  type        = string
  default     = null
}

variable "path" {
  description = "Caminho da policy IAM (padrão \"/\")."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/?$", var.path))
    error_message = "path deve iniciar com '/' e opcionalmente terminar com '/'."
  }
}
