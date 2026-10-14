variable "aws_region" {
  type        = string
  description = "Região da AWS onde os recursos serão criados"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Ambiente de implantação (ex: dev, hml, prod)"
  default     = "dev"
}

variable "role_name" {
  type        = string
  description = "Nome padronizado para a IAM Role"
}

variable "policy_name" {
  type        = string
  description = "Nome padronizado para a IAM Policy"
}

variable "trusted_service" {
  type        = string
  description = "Serviço AWS confiável autorizado a assumir a role (ex: ec2.amazonaws.com, lambda.amazonaws.com)"
  default     = "ec2.amazonaws.com"
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de ações permitidas na policy (ex: s3:GetObject, s3:PutObject)"
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de ARNs dos recursos específicos permitidos"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais opcionais para os recursos IAM"
  default     = {}
}
