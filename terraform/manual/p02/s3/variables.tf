variable "s3_bucket_name" {
  description = "Nome globalmente unico do bucket S3"
  type        = string
}

variable "environment" {
  description = "Ambiente do recurso"
  type        = string
  default     = "production"
}
