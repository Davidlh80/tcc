variable "bucket_name" {
  type        = string
  description = "nome globalmente unico para o bucket S3"
}

variable "environment" {
  type        = string
  description = "ambiente"
  default     = "dev"
}

variable "enable_versioning" {
  type        = bool
  description = "habilitar versionamento do bucket"
  default     = true
}
