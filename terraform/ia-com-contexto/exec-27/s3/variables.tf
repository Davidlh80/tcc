variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou projeto ao qual o bucket pertence, usado na nomenclatura padronizada."
  default     = "tcc"
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o bucket sera provisionado."
  default     = "us-east-1"
}

variable "purpose" {
  type        = string
  description = "Finalidade do bucket, usada na nomenclatura padronizada (ex.: logs, artifacts, backups)."

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose nao pode ser vazio."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "versioning_status" {
  type        = string
  description = "Status do versionamento do bucket S3."
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  type        = string
  description = "Algoritmo de criptografia server-side aplicado por padrao ao bucket."
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser AES256 ou aws:kms."
  }
}
