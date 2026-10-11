variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-app"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser uma VPC provisionada pelo ambiente de teste, nao a VPC padrao da conta."
  type        = string
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas do Security Group."
  type = list(object({
    description      = string
    from_port        = number
    to_port           = number
    protocol          = string
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = [
    {
      description      = "Acesso HTTPS interno"
      from_port        = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["10.0.0.0/16"]
      ipv6_cidr_blocks  = []
    }
  ]
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas do Security Group."
  type = list(object({
    description      = string
    from_port        = number
    to_port           = number
    protocol          = string
    cidr_blocks       = list(string)
    ipv6_cidr_blocks  = list(string)
  }))
  default = [
    {
      description      = "Saida HTTPS para atualizacoes e dependencias externas"
      from_port        = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
    }
  ]
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
