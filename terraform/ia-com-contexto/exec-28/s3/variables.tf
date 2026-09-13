variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou produto ao qual o recurso pertence."
  default     = "tcc"

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o bucket sera provisionado."
  default     = "us-east-1"
}

variable "purpose" {
  type        = string
  description = "Finalidade do bucket, utilizada na composicao do nome (ex.: logs, artifacts)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose))
    error_message = "O valor de purpose deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "versioning_status" {
  type        = string
  description = "Status do versionamento do bucket (Enabled ou Suspended)."
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

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas ao bucket, alem das tags obrigatorias da organizacao."
  default     = {}
}
