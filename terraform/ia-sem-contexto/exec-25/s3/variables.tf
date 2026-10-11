variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente unico e seguir as regras de nomenclatura da AWS."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, iniciando e terminando com letra ou numero."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex: dev, staging, prod), usado para tagueamento."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Define se o versionamento do bucket deve estar habilitado."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor. Valores aceitos: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS a ser usada quando sse_algorithm for 'aws:kms'. Ignorado caso contrario."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo que contenha objetos. Use com cautela."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
