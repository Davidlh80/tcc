variable "aws_region" {
  description = "Regiao AWS onde os recursos serao provisionados."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser a VPC provisionada pelo ambiente de teste, e nao a VPC default da conta."
  type        = string
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "tcc-security-group"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas. Nenhuma regra e criada por padrao; defina apenas o necessario para o cenario de teste."
  type = list(object({
    description = optional(string, "")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !(contains(rule.cidr_blocks, "0.0.0.0/0") && contains([22, 3389], rule.from_port))
    ])
    error_message = "Regras de entrada com cidr_blocks contendo 0.0.0.0/0 nao podem liberar as portas 22 (SSH) ou 3389 (RDP)."
  }
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
      description = "Permite saida HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
