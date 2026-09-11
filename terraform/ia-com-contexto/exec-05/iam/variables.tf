variable "environment" {
  description = "Ambiente de deploy (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (minúsculas, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,50}$", var.system))
    error_message = "system deve conter apenas [a-z0-9-] com até 50 caracteres."
  }
}

variable "region" {
  description = "Região AWS onde o provider operará."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o padrão de regiões AWS (ex.: us-east-1, sa-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas às tags obrigatórias."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy para compor o nome (ex.: readonly, s3-access)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,50}$", var.policy_name))
    error_message = "policy_name deve conter apenas [a-z0-9-] com até 50 caracteres."
  }
}

variable "allowed_actions" {
  description = "Lista de ações IAM a serem permitidas (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : trim(a) != ""])
    error_message = "allowed_actions não pode ser vazio e não deve conter strings vazias."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as ações serão permitidas."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : trim(r) != ""])
    error_message = "allowed_resources não pode ser vazio e não deve conter strings vazias."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada por Terraform conforme padrão organizacional."
}

variable "policy_path" {
  description = "Caminho da policy no IAM (ex.: \"/\" ou \"/app/\")."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/([A-Za-z0-9+=,.@_-]+/)*$", var.policy_path))
    error_message = "policy_path deve iniciar com '/' e, se não for raiz, terminar com '/'; apenas caracteres IAM válidos são permitidos."
  }
}
