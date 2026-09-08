variable "aws_region" {
  description = "AWS region to use for the provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region must match the pattern e.g., us-east-1."
  }
}

variable "policy_name" {
  description = "Name of the IAM policy. Avoid using names starting with 'AWS' which are reserved by AWS."
  type        = string
  default     = "iam-readonly-policy"
  validation {
    condition     = length(var.policy_name) > 0 && length(var.policy_name) <= 128 && !startswith(var.policy_name, "AWS")
    error_message = "policy_name must be 1-128 characters and must not start with 'AWS'."
  }
}

variable "policy_description" {
  description = "Description for the IAM policy. Do not include sensitive information."
  type        = string
  default     = "Customer managed IAM policy provisioned by Terraform."
  validation {
    condition     = length(var.policy_description) > 0 && length(var.policy_description) <= 1000
    error_message = "policy_description must be between 1 and 1000 characters."
  }
}

variable "policy_path" {
  description = "Path for the IAM policy. Must start and end with a forward slash."
  type        = string
  default     = "/"
  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "policy_path must start and end with '/'. Example: '/' or '/service-role/'."
  }
}

variable "actions" {
  description = "List of IAM actions to allow. Ignored if policy_json is provided."
  type        = list(string)
  default     = ["s3:Get*", "s3:List*"]
  validation {
    condition     = length(var.actions) > 0 && alltrue([for a in var.actions : length(trim(a)) > 0])
    error_message = "actions must be a non-empty list of non-empty strings."
  }
}

variable "resources" {
  description = "List of resource ARNs the actions apply to. Use '*' to allow all. Ignored if policy_json is provided."
  type        = list(string)
  default     = ["*"]
  validation {
    condition = length(var.resources) > 0 && alltrue([
      for r in var.resources :
      r == "*" || can(regex("^arn:(aws|aws-us-gov|aws-cn):[a-z0-9-]+:[a-z0-9-]*:[0-9]*:.+$", r))
    ])
    error_message = "resources must be a non-empty list where each item is '*' or a valid ARN."
  }
}

variable "policy_json" {
  description = "Optional raw JSON for the IAM policy document. If provided, overrides actions/resources. Must be a valid JSON string."
  type        = string
  default     = null
  validation {
    condition     = var.policy_json == null || can(jsondecode(var.policy_json))
    error_message = "policy_json must be null or a valid JSON string."
  }
}

variable "tags" {
  description = "Map of tags to assign to the IAM policy."
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for k, v in var.tags : length(trim(k)) > 0 && !startswith(lower(k), "aws:")])
    error_message = "All tag keys must be non-empty and must not start with 'aws:'."
  }
}
