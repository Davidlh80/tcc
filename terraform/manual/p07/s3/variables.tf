variable "region" {
  description = "Regiao AWS do bucket."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket (unico globalmente)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name deve ter entre 3 e 63 caracteres, com letras minusculas, numeros, ponto ou hifen."
  }
}

variable "environment" {
  description = "Ambiente (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "enable_versioning" {
  description = "Liga ou desliga o versionamento do bucket."
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Tags adicionais para o bucket."
  type        = map(string)
  default     = {}
}
