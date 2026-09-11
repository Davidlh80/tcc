variable "environment" {
  description = "Ambiente alvo. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um de: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema (minúsculas, dígitos e hífens). Ex.: tcc"
  type        = string

  validation {
    condition     = length(var.system) > 0 && can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O system deve conter apenas [a-z0-9-] e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o bucket será criado. Ex.: us-east-1"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}(-gov)?-[a-z]+-\\d$", var.region))
    error_message = "A região deve seguir o formato padrão, por exemplo: us-east-1, eu-west-1 ou us-gov-west-1."
  }
}

variable "purpose" {
  description = "Finalidade do bucket (minúsculas, dígitos e hífens). Ex.: logs, assets, backups"
  type        = string

  validation {
    condition     = length(var.purpose) > 0 && can(regex("^[a-z0-9-]+$", var.purpose))
    error_message = "A purpose deve conter apenas [a-z0-9-] e não pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3. Valores permitidos: Enabled, Suspended. Padrão: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side do S3. Conforme política, somente AES256 (SSE-S3) é permitido."
  type        = string
  default     = "AES256"

  validation {
    condition     = var.sse_algorithm == "AES256"
    error_message = "Conforme política organizacional, apenas AES256 (SSE-S3) é permitido para sse_algorithm."
  }
}

variable "force_destroy" {
  description = "Quando true, força a destruição do bucket mesmo se contiver objetos."
  type        = bool
  default     = false
}
