variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group será provisionado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato vpc-xxxxxxxx."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "app-sg"
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explícitas do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Acesso HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]
}

variable "egress_rules" {
  description = "Lista de regras de saída explícitas do Security Group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Saída HTTPS para atualizações e integrações externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
