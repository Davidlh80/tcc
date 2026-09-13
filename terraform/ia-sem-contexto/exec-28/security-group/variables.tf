variable "aws_region" {
  description = "Regiao AWS onde o Security Group sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser a VPC provisionada pelo ambiente de teste, nao a VPC default da conta."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "example-sg"

  validation {
    condition     = length(var.name) > 0
    error_message = "O valor de name nao pode ser vazio."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress). Nenhuma porta e liberada por padrao; defina explicitamente as regras necessarias."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Por padrao, permite todo trafego de saida (pratica comum para SGs), mas pode ser restringido conforme necessidade."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite todo trafego de saida"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
