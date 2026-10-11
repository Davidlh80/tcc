variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser a VPC provisionada pelo ambiente de teste, nao a VPC default da conta."
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
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform com regras explicitas de entrada e saida."
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas. Evite usar 0.0.0.0/0 a menos que seja estritamente necessario."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Acesso HTTPS a partir da rede interna da VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
}

variable "egress_rules" {
  description = "Lista de regras de saida explicitas."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Acesso HTTPS de saida para atualizacoes e integracoes externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Resolucao DNS"
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
