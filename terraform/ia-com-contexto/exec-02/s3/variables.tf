variable "environment" {
  description = "Ambiente alvo do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O ambiente deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação. Use apenas letras minúsculas, números e hífens."
  type        = string

  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*)$", var.system)) && length(var.system) >= 1 && length(var.system) <= 55
    error_message = "system deve conter apenas [a-z0-9-], sem iniciar/terminar com hífen, e ter entre 1 e 55 caracteres."
  }
}

variable "purpose" {
  description = "Finalidade do recurso dentro do sistema (ex.: logs, assets, backups)."
  type        = string

  validation {
    condition     = can(regex("^([a-z0-9]+(-[a-z0-9]+)*)$", var.purpose)) && length(var.purpose) >= 1 && length(var.purpose) <= 55
    error_message = "purpose deve conter apenas [a-z0-9-], sem iniciar/terminar com hífen, e ter entre 1 e 55 caracteres."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão criados (ex.: us-east-1)."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "region não pode ser vazia."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3. Valores permitidos: Enabled, Suspended."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Padrão AES256 (SSE-S3). Valores permitidos: AES256, aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ARN/ID da KMS Key quando sse_algorithm = aws:kms. Obrigatório nesse caso; ignorado quando AES256."
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Quando true, permite destruir o bucket mesmo contendo objetos."
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas às tags obrigatórias."
  type        = map(string)
  default     = {}
}
