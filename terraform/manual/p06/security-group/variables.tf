variable "aws_region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "sa-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o security group sera criado."
  type        = string
}

variable "name" {
  description = "Nome do security group."
  type        = string
  default     = "p06-app"
}

variable "app_port" {
  description = "Porta TCP liberada para a aplicacao."
  type        = number
  default     = 443
}

variable "allowed_cidr_blocks" {
  description = "CIDRs autorizados a acessar a porta da aplicacao."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "Tags aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
