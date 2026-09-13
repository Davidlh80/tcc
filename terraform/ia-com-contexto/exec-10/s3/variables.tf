variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/projeto ao qual o recurso pertence, usado na nomenclatura padrao."
  type        = string
  default     = "tcc"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas e numeros."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera criado."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket, usada na nomenclatura padrao <ambiente>-<sistema>-<recurso>-<finalidade>."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose))
    error_message = "O valor de purpose deve conter apenas letras minusculas, numeros e hifens."
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
