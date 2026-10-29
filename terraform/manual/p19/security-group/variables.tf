variable "aws_region" {
  description = "Região AWS usada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "example-sg"
}

variable "description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerido por Terraform."
}

variable "vpc_id" {
  description = "ID da VPC onde criar o Security Group."
  type        = string
}

variable "ingress_rules" {
  description = "Lista de regras de entrada."
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = [
    {
      description = "SSH de exemplo; restrinja ao seu IP antes de usar."
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.10/32"]
    }
  ]
}

variable "egress_rules" {
  description = "Lista de regras de saída."
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  default = [
    {
      description = "Saída IPv4 para qualquer destino (exemplo)."
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
