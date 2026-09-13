variable "environment" {
  description = "Ambiente de implantacao do recurso. Deve ser um dos ambientes permitidos pela organizacao."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou produto proprietario do recurso, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o bucket sera criado."
  type        = string

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "purpose" {
  description = "Finalidade do bucket, usada na nomenclatura padronizada (ex.: logs, artifacts)."
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

variable "kms_key_id" {
  description = "ID ou ARN da chave KMS utilizada quando sse_algorithm for aws:kms. Ignorado quando sse_algorithm for AES256."
  type        = string
  default     = null
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}
