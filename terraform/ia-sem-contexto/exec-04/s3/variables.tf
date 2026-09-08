variable "aws_region" {
  description = "Região AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region não pode ser vazio."
  }
}

variable "aws_profile" {
  description = "Profile do AWS CLI (opcional). Se não definido, segue a cadeia de credenciais padrão."
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "Nome do bucket S3 (globally unique). Use apenas letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name deve conter de 3 a 63 caracteres, apenas letras minúsculas, números e hífens, começando e terminando com alfanumérico."
  }
}

variable "environment" {
  description = "Valor para a tag Environment."
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "environment deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "tags" {
  description = "Mapa de tags adicionais para aplicar aos recursos."
  type        = map(string)
  default     = {}
}

variable "enable_versioning" {
  description = "Habilita o versionamento do bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo se não estiver vazio."
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Bloqueia todas as formas de acesso público ao bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor. Valores válidos: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ID/ARN da KMS Key quando sse_algorithm = aws:kms. Se não informado, usa a chave gerenciada pela AWS (alias/aws/s3)."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Habilita S3 Bucket Keys para reduzir chamadas ao KMS quando aws:kms for utilizado."
  type        = bool
  default     = true
}

variable "attach_ssl_tls_policy" {
  description = "Anexa uma bucket policy que nega tráfego sem TLS."
  type        = bool
  default     = true
}
