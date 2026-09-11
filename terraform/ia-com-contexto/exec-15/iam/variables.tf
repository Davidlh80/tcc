variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (ex.: tcc). Deve conter apenas letras minúsculas, números e hifens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,}$", var.system))
    error_message = "O sistema deve usar apenas [a-z0-9-] e ter no mínimo 2 caracteres."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão gerenciados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o padrão, por exemplo: us-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Nome lógico da política (segmento 'finalidade' do padrão de nomenclatura). Ex.: readonly, s3-access."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,}$", var.policy_name))
    error_message = "O policy_name deve usar apenas [a-z0-9-] e ter no mínimo 2 caracteres."
  }
}

variable "allowed_actions" {
  description = "Lista de actions IAM a serem permitidas (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && length(compact(var.allowed_actions)) == length(var.allowed_actions)
    error_message = "allowed_actions não pode ser vazio nem conter strings vazias."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos a serem permitidos ou \"*\" quando aplicável."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && length(compact(var.allowed_resources)) == length(var.allowed_resources)
    error_message = "allowed_resources não pode ser vazio nem conter strings vazias."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada por Terraform conforme padrão organizacional."
}

variable "policy_path" {
  description = "Caminho da policy (deve iniciar e terminar com '/')."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$", var.policy_path))
    error_message = "O policy_path deve iniciar e terminar com '/'. Ex.: '/', '/application/'."
  }
}
