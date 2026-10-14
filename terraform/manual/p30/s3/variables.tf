variable "environment" {
  description = "Ambiente usado no nome e nas tags do bucket."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema usado no nome do bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.system)) && length(var.system) <= 20
    error_message = "system deve conter até 20 caracteres minúsculos, números ou hífens, sem hífen inicial ou final."
  }
}

variable "region" {
  description = "Região AWS onde o bucket será criado."
  type        = string

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region não pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Tags adicionais opcionais. As tags obrigatórias são aplicadas depois e não podem ser sobrescritas."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Finalidade usada no nome do bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.purpose)) && length(var.purpose) <= 20
    error_message = "purpose deve conter até 20 caracteres minúsculos, números ou hífens, sem hífen inicial ou final."
  }
}

variable "versioning_status" {
  description = "Estado do versionamento do bucket."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Suspended"], var.versioning_status)
    error_message = "versioning_status deve ser Enabled ou Suspended."
  }
}

variable "required_tags" {
  description = "Tags organizacionais obrigatórias, com valores definidos pelo padrão interno."
  type        = map(string)
  default = {
    Project    = "tcc-iac-ia"
    ManagedBy  = "terraform"
    Owner      = "devops"
    CostCenter = "academic-research"
  }

  validation {
    condition = alltrue([
      for key in ["Project", "ManagedBy", "Owner", "CostCenter"] :
      contains(keys(var.required_tags), key)
    ]) && var.required_tags.Project == "tcc-iac-ia" && var.required_tags.ManagedBy == "terraform" && var.required_tags.Owner == "devops" && var.required_tags.CostCenter == "academic-research"
    error_message = "required_tags deve conter Project, ManagedBy, Owner e CostCenter com os valores organizacionais definidos."
  }
}
