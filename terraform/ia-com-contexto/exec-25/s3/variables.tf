variable "environment" {
  description = "Ambiente de implantacao do recurso. Deve ser um dos valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema ao qual o recurso pertence, utilizado no padrao de nomenclatura."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera provisionado."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "purpose" {
  description = "Finalidade do bucket S3, utilizada no padrao de nomenclatura (ex.: logs)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side aplicado por padrao ao bucket (SSE-S3/AES256 ou SSE-KMS)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled, Suspended ou Disabled."
  }
}
