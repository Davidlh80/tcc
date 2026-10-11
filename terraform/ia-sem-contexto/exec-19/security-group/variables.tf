variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-managed-by-terraform"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform."
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "O valor de vpc_id nao pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras explicitas de entrada (ingress) do Security Group."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = [
    {
      description      = "Permite trafego HTTPS de entrada a partir de uma rede interna especifica."
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/16"]
      ipv6_cidr_blocks = []
    }
  ]
}

variable "egress_rules" {
  description = "Lista de regras explicitas de saida (egress) do Security Group."
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = [
    {
      description      = "Permite trafego HTTPS de saida para qualquer destino."
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    },
    {
      description      = "Permite resolucao DNS de saida (UDP/53) para qualquer destino."
      from_port        = 53
      to_port          = 53
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
