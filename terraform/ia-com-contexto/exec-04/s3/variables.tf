variable "environment" {
  description = "Ambiente de implantação. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculas, números e hifens). Ex.: tcc"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && !can(regex("(^-)|(-$)", var.system))
    error_message = "O system deve conter apenas [a-z0-9-] e não pode iniciar/terminar com hífen."
  }
}

variable "region" {
  description = "Região AWS onde o bucket será criado. Ex.: us-east-1"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.region))
    error_message = "A region deve respeitar o padrão AWS, ex.: us-east-1, sa-east-1."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a aplicar em todos os recursos que suportam tags. As tags mandatórias da organização prevalecem em caso de conflito."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade do bucket (minúsculas, números e hifens). Ex.: logs, artifacts, backups"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && !can(regex("(^-)|(-$)", var.purpose))
    error_message = "O purpose deve conter apenas [a-z0-9-] e não pode iniciar/terminar com hífen."
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket S3. Valores permitidos: Enabled, Suspended. Padrão: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Política organizacional: AES256 (SSE-S3)."
  type        = string
  default     = "AES256"

  validation {
    condition     = var.sse_algorithm == "AES256"
    error_message = "De acordo com a política organizacional, apenas AES256 (SSE-S3) é permitido."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo contendo objetos (use com cautela)."
  type        = bool
  default     = false
}
