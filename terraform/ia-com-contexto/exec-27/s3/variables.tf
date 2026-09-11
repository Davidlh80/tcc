variable "environment" {
  description = "Ambiente da implantação. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema (minúsculo, números e hífens). Ex.: tcc"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "purpose" {
  description = "Finalidade do recurso no padrão de nomenclatura. Ex.: logs, data, assets."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.purpose)) && length(var.purpose) > 0
    error_message = "purpose deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "region" {
  description = "Região AWS onde o bucket será criado. Ex.: us-east-1"
  type        = string

  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca|af|me)-[a-z]+-\\d$", var.region))
    error_message = "region deve estar no formato válido de região AWS. Ex.: us-east-1"
  }
}

variable "versioning_status" {
  description = "Status do versionamento do bucket. Valores permitidos: Enabled, Suspended. Padrão: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "sse_algorithm" {
  description = "Algoritmo de criptografia server-side. Valores permitidos: AES256 (padrão) ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm deve ser AES256 ou aws:kms."
  }
}

variable "kms_key_id" {
  description = "ARN ou ID da CMK quando sse_algorithm=aws:kms. Obrigatório se utilizar KMS."
  type        = string
  default     = null

  validation {
    condition     = var.sse_algorithm != "aws:kms" || (var.sse_algorithm == "aws:kms" && var.kms_key_id != null && length(trim(var.kms_key_id)) > 0)
    error_message = "kms_key_id é obrigatório quando sse_algorithm for aws:kms."
  }
}

variable "force_destroy" {
  description = "Se true, permite destruir o bucket mesmo se não estiver vazio."
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas. Não pode sobrescrever as tags obrigatórias."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(setintersection(toset(keys(var.additional_tags)), toset(["Project", "Environment", "ManagedBy", "Owner", "CostCenter"]))) == 0
    error_message = "additional_tags não pode sobrescrever as tags obrigatórias: Project, Environment, ManagedBy, Owner, CostCenter."
  }
}
