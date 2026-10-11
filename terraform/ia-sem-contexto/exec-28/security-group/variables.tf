variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser o ID de uma VPC previamente provisionada pelo ambiente (nao a VPC default da conta)."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, no formato 'vpc-xxxxxxxx'."
  }
}

variable "ingress_rules" {
  description = "Lista de regras explicitas de entrada do Security Group. Nenhuma regra e criada por padrao; cada regra deve ser declarada de forma explicita pelo consumidor do modulo."
  type = list(object({
    description      = string
    from_port        = number
    to_port           = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "Lista de regras explicitas de saida do Security Group. O padrao libera apenas HTTPS (443) de saida, evitando liberacao irrestrita de todas as portas e protocolos."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = [
    {
      description      = "Permite trafego HTTPS de saida."
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
