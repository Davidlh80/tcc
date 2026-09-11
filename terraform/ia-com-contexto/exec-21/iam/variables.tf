variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão gerenciados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "region não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso (as tags obrigatórias serão mantidas)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Nome/finalidade da policy, usado na nomenclatura <environment>-<system>-iam-<policy_name>."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0 && can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações a serem permitidas (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions não pode ser vazio."
  }

  validation {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Proibido usar Action \"*\" em conjunto com Resource \"*\" na mesma policy."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos a serem permitidos (ex.: [\"arn:aws:s3:::meu-bucket\", \"arn:aws:s3:::meu-bucket/*\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources não pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy. Se vazio, será gerada uma descrição padrão."
  type        = string
  default     = ""
}

variable "policy_path" {
  description = "Caminho da IAM Policy (ex.: \"/\" ou \"/app/\")."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/([A-Za-z0-9+=,.@_-]+/)?$", var.policy_path)) || var.policy_path == "/"
    error_message = "policy_path deve ser \"/\" ou um caminho com formato válido, como \"/app/\"."
  }
}
