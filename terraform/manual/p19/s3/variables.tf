variable "aws_region" {
  description = "Região AWS usada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente único do bucket S3."
  type        = string
}

variable "tags" {
  description = "Tags aplicadas ao bucket."
  type        = map(string)
  default     = {}
}
