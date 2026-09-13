variable "environment" {
  description = "Ambiente de implantacao do recurso. Deve ser um dos valores permitidos pela organizacao."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema ou aplicacao dona do recurso, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket S3, usada na nomenclatura padronizada (ex.: logs, artifacts, backups)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose nao pode ser vazio."
  }
}

variable "enable_versioning" {
  description = "Habilita o versionamento do bucket S3. Quando verdadeiro, o status sera Enabled; caso contrario, Suspended."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side aplicado por padrao ao bucket. Padrao organizacional: AES256 (SSE-S3)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "O valor de sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_master_key_id" {
  description = "ID ou ARN da chave KMS usada para criptografia quando sse_algorithm for aws:kms. Ignorado quando o algoritmo for AES256."
  type        = string
  default     = null
}
