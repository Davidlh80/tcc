variable "security_group_name" {
  description = "Nome padronizado do Security Group."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string
}

variable "environment" {
  description = "Ambiente de implantação."
  type        = string
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado pelo Terraform"
}

variable "ingress_rules" {
  description = "Regras de entrada explícitas."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "Regras de saída explícitas."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    description = "HTTPS para endpoints externos necessários"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
variable "aws_region" {
  description = "Região AWS para o provider."
  type        = string
  default     = "us-east-1"
}
