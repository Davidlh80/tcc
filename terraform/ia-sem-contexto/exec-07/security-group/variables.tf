variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "app-sg"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. Nenhuma regra e criada por padrao (postura segura por padrao)."
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
  description = "Lista de regras de saida do Security Group. Por padrao, permite todo trafego de saida (padrao comum em ambientes AWS)."
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
