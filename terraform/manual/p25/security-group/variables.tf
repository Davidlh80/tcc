variable "aws_region" {
  type        = string
  description = "Região da AWS onde os recursos serão criados"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Ambiente de implantação (ex: dev, hml, prod)"
  default     = "dev"
}

variable "sg_name" {
  type        = string
  description = "Nome do Security Group"
}

variable "sg_description" {
  type        = string
  description = "Descrição clara justificando a finalidade do Security Group"
  default     = "Security Group gerenciado por Terraform"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Security Group será alocado"
}

# Lista de regras de entrada (Ingress) estruturadas e restritas
variable "ingress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Lista de regras de tráfego de entrada permitidas"
  default     = []
}

# Regra de saída (Egress) padrão (geralmente liberada para a internet em muitos cenários, mas controlada)
variable "egress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Lista de regras de tráfego de saída permitidas"
  default = [
    {
      description = "Permitir todo o tráfego de saída por padrão"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais opcionais para o Security Group"
  default     = {}
}
