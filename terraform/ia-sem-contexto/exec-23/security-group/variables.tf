variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera provisionado."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, iniciando com \"vpc-\"."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "app-sg"

  validation {
    condition     = length(var.name) > 0
    error_message = "O valor de name nao pode ser vazio."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas a serem aplicadas ao Security Group. Nenhuma regra e aberta por padrao."
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
  description = "Lista de regras de saida explicitas a serem aplicadas ao Security Group. Por padrao, permite apenas trafego HTTPS de saida."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS de saida"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
