variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente unico e seguir as regras de nomenclatura da AWS."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "O nome do bucket deve ter entre 3 e 63 caracteres, usando apenas letras minusculas, numeros, pontos e hifens, comecando e terminando com letra ou numero."
  }
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Permite a exclusao do bucket mesmo que ele contenha objetos. Use com cautela em ambientes produtivos."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita o versionamento de objetos no bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side padrao do bucket. Valores validos: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser \"AES256\" ou \"aws:kms\"."
  }
}

variable "kms_master_key_id" {
  description = "ARN ou ID da chave KMS utilizada para criptografia, obrigatorio quando sse_algorithm for \"aws:kms\"."
  type        = string
  default     = null
}

variable "block_public_access" {
  description = "Quando verdadeiro, bloqueia todo acesso publico ao bucket (ACLs e politicas de bucket)."
  type        = bool
  default     = true
}
