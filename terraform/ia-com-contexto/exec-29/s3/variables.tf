variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Nome do sistema ou projeto ao qual o recurso pertence, utilizado na nomenclatura padronizada."
  type        = string
  default     = "tcc"
}

variable "region" {
  description = "Regiao AWS onde o bucket S3 sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket, utilizada na nomenclatura padronizada (ex.: logs, artifacts)."
  type        = string

  validation {
    condition     = length(trimspace(var.purpose)) > 0
    error_message = "O valor de purpose nao pode ser vazio."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side aplicado por padrao ao bucket."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS utilizada quando sse_algorithm for aws:kms. Nao utilizado quando o algoritmo for AES256."
  type        = string
  default     = null
}
