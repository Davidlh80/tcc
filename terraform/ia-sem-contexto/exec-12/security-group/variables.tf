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
  default     = "sg-blueprint"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas do Security Group. Evite usar 0.0.0.0/0 a menos que seja estritamente necessario."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Permite trafego HTTPS originado de dentro da VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas do Security Group. Evite liberar todas as portas e protocolos sem necessidade."
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
    },
    {
      description = "Permite resolucao DNS de saida (UDP)"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags adicionais a serem aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
