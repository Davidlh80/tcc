variable "environment" {
  description = "Ambiente de implantação do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação proprietária do recurso, utilizado na composição do nome padronizado."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket, utilizada na composição do nome padronizado (ex.: logs, artifacts, backups)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose não pode ser vazio."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3 (Enabled ou Suspended)."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side aplicado por padrão ao bucket (AES256 ou aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ID ou ARN da chave KMS utilizada quando sse_algorithm for aws:kms. Ignorado quando o algoritmo for AES256."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Permite a exclusão do bucket mesmo que contenha objetos. Recomendado manter false em produção."
  type        = bool
  default     = false
}
