variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "sa-east-1"
}

variable "role_name" {
  description = "Nome da role IAM da aplicacao."
  type        = string
  default     = "p06-app-role"
}

variable "trusted_service" {
  description = "Servico AWS autorizado a assumir a role."
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "bucket_name" {
  description = "Nome do bucket S3 que a role pode ler."
  type        = string
}

variable "object_prefix" {
  description = "Prefixo dos objetos que a role pode ler. Sem barra no inicio."
  type        = string
  default     = "app/"
}

variable "tags" {
  description = "Tags aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
