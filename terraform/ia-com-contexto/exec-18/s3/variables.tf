variable "environment" {
  type        = string
  description = "Ambiente de implantação do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicação proprietária do recurso."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde o bucket será criado."
  default     = "us-east-1"
}

variable "purpose" {
  type        = string
  description = "Finalidade do bucket, utilizada na composição do nome (ex.: logs, backups)."

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose não pode ser vazio."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização."
  default     = {}
}

variable "versioning_status" {
  type        = string
  description = "Status do versionamento do bucket."
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  type        = string
  description = "Algoritmo de criptografia server-side padrão do bucket."
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  type        = string
  description = "ARN da chave KMS utilizada quando sse_algorithm for aws:kms. Ignorado quando AES256."
  default     = null
}
