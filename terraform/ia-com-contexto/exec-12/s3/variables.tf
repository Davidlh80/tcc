variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser 'dev', 'hml' ou 'prd'."
  }
}

variable "system" {
  type        = string
  description = "Identificador do sistema/aplicacao proprietaria do recurso."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o bucket sera provisionado."
  default     = "us-east-1"
}

variable "purpose" {
  type        = string
  description = "Finalidade do bucket, usada na composicao do nome padronizado."

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
    error_message = "O valor de versioning_status deve ser 'Enabled' ou 'Suspended'."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais mescladas as tags obrigatorias da organizacao."
  default     = {}
}
