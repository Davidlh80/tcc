variable "aws_region" {
  description = "Regiao da AWS"
  type        = string
  default     = "us-east-1"
}

variable "iam_role_name" {
  description = "Nome da IAM Role"
  type        = string
  default     = "app-role"
}

variable "iam_policy_name" {
  description = "Nome da IAM Policy"
  type        = string
  default     = "app-policy"
}
