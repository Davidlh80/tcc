variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema/aplicacao dono do recurso."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o bucket sera criado."
  type        = string
  default     = "us-east-1"
}

variable "purpose" {
  description = "Finalidade do bucket, usada no padrao de nomenclatura (ex.: logs, artifacts)."
  type        = string

  validation {
    condition     = length(trimspace(var.purpose)) > 0
    error_message = "purpose nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias."
  type        = map(string)
  default     = {}
}

variable "versioning_status" {
  description = "Status do versionamento do bucket (Enabled ou Suspended)."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side padrao do bucket (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ID ou ARN da chave KMS a ser usada quando sse_algorithm for aws:kms."
  type        = string
  default     = null
}
