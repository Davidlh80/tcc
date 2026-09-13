variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto ao qual o recurso pertence."
  type        = string

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera provisionado."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "purpose" {
  description = "Finalidade do bucket, utilizada na composicao do nome (ex.: logs, artifacts)."
  type        = string

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose nao pode ser vazio."
  }
}

variable "versioning_status" {
  description = "Estado do versionamento do bucket (Enabled ou Suspended)."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "O valor de versioning_status deve ser Enabled ou Suspended."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias."
  type        = map(string)
  default     = {}
}
