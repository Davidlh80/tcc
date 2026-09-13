variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-default"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Nao defina CIDRs amplos (0.0.0.0/0) a menos que seja intencional."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "HTTPS from internal network"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  ]
}

variable "egress_rules" {
  description = "Lista de regras de saida."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
