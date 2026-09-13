variable "vpc_id" {
  type        = string
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera provisionado."

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato de um ID de VPC valido da AWS, por exemplo: vpc-0123456789abcdef0."
  }
}

variable "name" {
  type        = string
  description = "Nome do Security Group."
  default     = "app-sg"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "O nome deve ter entre 1 e 255 caracteres."
  }
}

variable "description" {
  type        = string
  description = "Descricao do Security Group."
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  type = list(object({
    description = optional(string, "Ingress rule managed by Terraform")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Lista de regras de entrada. Vazia por padrao para nao expor portas sem uma decisao explicita."
  default     = []
}

variable "egress_rules" {
  type = list(object({
    description = optional(string, "Egress rule managed by Terraform")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Lista de regras de saida."
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
  type        = map(string)
  description = "Tags adicionais aplicadas ao Security Group."
  default     = {}
}
