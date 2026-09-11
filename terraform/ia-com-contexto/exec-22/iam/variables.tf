variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema (segmento do nome do recurso). Use letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider (ex.: us-east-1)."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "region deve seguir o padrão de regiões AWS (ex.: us-east-1)."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a aplicar nos recursos. As tags obrigatórias serão aplicadas e têm precedência."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da policy (segmento final do nome). Ex.: readonly, s3-access."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações explícitas a permitir (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions não pode ser vazio."
  }
}

variable "allowed_resource_arns" {
  description = "Lista de ARNs de recursos a permitir (ex.: [\"arn:aws:s3:::bucket\", \"arn:aws:s3:::bucket/*\"]). Pode incluir \"*\" desde que as ações não sejam \"*\" simultaneamente."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resource_arns) > 0
    error_message = "allowed_resource_arns não pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "IAM policy gerenciada pela organização via Terraform."
}
