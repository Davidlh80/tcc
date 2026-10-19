variable "policy_name" {
  description = "Nome da policy IAM"
  type        = string
}

variable "role_name" {
  description = "Nome da role IAM"
  type        = string
}

variable "environment" {
  description = "Ambiente onde o recurso sera utilizado"
  type        = string
  default     = "dev"
}

variable "trusted_principal" {
  description = "Principal autorizado a assumir a role"
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "allowed_actions" {
  description = "Acoes permitidas pela policy"
  type        = list(string)

  default = [
    "s3:GetObject",
    "s3:ListBucket"
  ]
}

variable "allowed_resources" {
  description = "Recursos que podem ser acessados pela policy"
  type        = list(string)

  default = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]
}
