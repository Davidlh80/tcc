variable "sg_name" {
  type        = string
  description = "Nome do Security Group"
  default     = "meu-security-group"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o SG sera criado"
}

variable "environment" {
  type        = string
  description = "Ambiente"
  default     = "dev"
}
