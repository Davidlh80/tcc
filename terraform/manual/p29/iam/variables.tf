variable "environment" {
  type        = string
  description = "Ambiente de execucao exemplo dev,prod, hml"
  default     = "dev"
}

variable "policy_name" {
  type        = string
  description = "Nome da politica IAM"
  default     = "exemplo-policy"
}

variable "role_name" {
  type        = string
  description = "Nome da role IAM"
  default     = "exemplo-role"
}
