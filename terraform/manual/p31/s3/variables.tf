variable "aws_region" {
  description = "Regiao AWS na qual os recursos serao gerenciados."
  type        = string

  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region nao pode ser vazia."
  }
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket S3."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) <= 63
    error_message = "bucket_name deve ter de 3 a 63 caracteres, usar letras minusculas, numeros, pontos ou hifens e comecar/terminar em letra ou numero."
  }
}

variable "environment" {
  description = "Ambiente usado nas tags do bucket."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser dev, staging ou prod."
  }
}

variable "versioning_enabled" {
  description = "Habilita versionamento dos objetos do bucket."
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Tags adicionais. Tags padrao de ambiente, projeto, gestao e nome sempre prevalecem."
  type        = map(string)
  default     = {}
}
