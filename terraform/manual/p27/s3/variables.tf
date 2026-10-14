variable "bucket_name" {
  description = "Nome globalmente exclusivo do bucket."
  type        = string

  validation {
    condition = (
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex(
        "^[a-z0-9][a-z0-9.-]*[a-z0-9]$",
        var.bucket_name
      )) &&
      !strcontains(var.bucket_name, "..") &&
      !can(regex(
        "^[0-9]{1,3}(\\.[0-9]{1,3}){3}$",
        var.bucket_name
      )) &&
      !can(regex(
        "^[0-9]+-[a-z]+-s3alias$",
        var.bucket_name
      ))
    )
    error_message = "Nome invalido para um bucket S3."
  }
}

variable "environment" {
  description = "Ambiente de implantacao."
  type        = string

  validation {
    condition = contains(
      ["dev", "hml", "stg", "prod"],
      var.environment
    )
    error_message = "Use dev, hml, stg ou prod."
  }
}

variable "versioning_enabled" {
  description = "Habilita o versionamento do bucket."
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Tags adicionais sem sobrescrita das tags obrigatorias."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.additional_tags :
      trimspace(key) != "" &&
      trimspace(value) != "" &&
      !contains(
        ["Environment", "ManagedBy", "Component"],
        key
      )
    ])
    error_message = "Tags vazias ou tentativa de sobrescrever tags obrigatorias."
  }
}
