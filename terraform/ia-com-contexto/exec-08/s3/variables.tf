variable "environment" {
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema ou produto ao qual o recurso pertence, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "purpose" {
  description = "Finalidade do bucket S3, usada na nomenclatura padronizada (ex.: logs, artifacts, backups)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3. Valores permitidos: Enabled, Suspended."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled ou Suspended."
  }
}
