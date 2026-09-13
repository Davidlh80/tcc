variable "environment" {
  description = "Ambiente de implantação do recurso (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema ou aplicação dona do recurso, usado na nomenclatura padronizada."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS onde o bucket S3 será criado."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region não pode ser vazio."
  }
}

variable "purpose" {
  description = "Finalidade do bucket, usada na nomenclatura padronizada (ex.: logs, artifacts, backups)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose não pode ser vazio."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled ou Suspended."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias da organização."
  type        = map(string)
  default     = {}
}
