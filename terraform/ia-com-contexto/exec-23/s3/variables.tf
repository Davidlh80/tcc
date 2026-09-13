variable "environment" {
  description = "Ambiente de implantação do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema ou aplicação proprietária do recurso, usado na composição do nome padronizado."
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
  description = "Finalidade do bucket, usada na composição do nome padronizado (ex.: logs, artifacts, backups)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose não pode ser vazio."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Valores permitidos: Enabled, Suspended."
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
