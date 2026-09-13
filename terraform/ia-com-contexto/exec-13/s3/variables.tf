variable "environment" {
  type        = string
  description = "Ambiente de implantacao do recurso."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicacao proprietaria do recurso."

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS onde o bucket sera provisionado."

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "purpose" {
  type        = string
  description = "Finalidade do bucket, utilizada na composicao do nome (ex: logs, artifacts)."

  validation {
    condition     = length(var.purpose) > 0
    error_message = "O valor de purpose nao pode ser vazio."
  }
}

variable "versioning" {
  type        = string
  description = "Status do versionamento do bucket (Enabled ou Suspended)."
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning)
    error_message = "O valor de versioning deve ser Enabled ou Suspended."
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias."
  default     = {}
}
