variable "aws_region" {
  description = "AWS region where the bucket will be created."
  type        = string
}

variable "bucket_name" {
  description = "Globally unique name of the S3 bucket."
  type        = string
}

variable "environment" {
  description = "Environment associated with the bucket."
  type        = string
}

variable "versioning_enabled" {
  description = "Enable object versioning; false suspends versioning."
  type        = bool
  default     = true
  nullable    = false
}

variable "force_destroy" {
  description = "Allow bucket deletion even when it contains objects and versions."
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "Additional tags applied to the bucket."
  type        = map(string)
  default     = {}
}
