variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso (dev, hml ou prd)."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicacao ao qual o bucket pertence, utilizado na composicao do nome do recurso."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o bucket S3 sera criado."
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "purpose" {
  type        = string
  description = "Finalidade do bucket, utilizada na composicao do nome do recurso (ex.: logs, artifacts, backups)."

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose nao pode ser vazio."
  }
}

variable "versioning_status" {
  type        = string
  description = "Status do versionamento do bucket S3."
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  type        = string
  description = "Algoritmo de criptografia server-side aplicado ao bucket (padrao AES256/SSE-S3)."
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_master_key_id" {
  type        = string
  description = "ARN da chave KMS utilizada na criptografia, obrigatorio apenas quando sse_algorithm for aws:kms."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "Permite a exclusao do bucket mesmo que contenha objetos. Deve permanecer false em ambientes produtivos."
  default     = false
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}
