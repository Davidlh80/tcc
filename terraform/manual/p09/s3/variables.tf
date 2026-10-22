variable "region" {
  type        = string
  description = "Region to allocate the created resource"
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "S3 name"
}


variable "owner" {
  type        = string
  description = "E-mail of the owner of the resource"
}

variable "environment" {
  type        = string
  description = "Environment (dev, hml or prd)"

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment must be dev, hml or prd."
  }
}

variable "versioning_enabled" {
  type        = bool
  description = "Defines if versioning is enabled in the created bucket"
  default     = true
}
