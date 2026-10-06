variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "sa-east-1"
}

variable "bucket_name" {
  description = "Nome globalmente unico do bucket de dados."
  type        = string
}

variable "log_bucket_name" {
  description = "Nome globalmente unico do bucket de logs de acesso."
  type        = string
}

variable "tags" {
  description = "Tags aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
