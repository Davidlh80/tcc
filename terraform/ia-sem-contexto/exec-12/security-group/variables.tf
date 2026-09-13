variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-application"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (ingress) do Security Group. Nenhuma regra e permitida por padrao (secure by default)."
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
  description = "Lista de regras de saida (egress) do Security Group."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite todo o trafego de saida"
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
