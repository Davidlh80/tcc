variable "region" {
  description = "Regiao AWS onde o Security Group sera provisionado."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato 'vpc-xxxxxxxx'."
  }
}

variable "name_prefix" {
  description = "Prefixo utilizado para nomear o Security Group."
  type        = string
  default     = "app"

  validation {
    condition     = length(var.name_prefix) > 0
    error_message = "O valor de name_prefix nao pode ser vazio."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada (inbound) do Security Group. Por padrao, nenhuma porta e liberada."
  type = list(object({
    description = optional(string, "Regra de entrada gerenciada via Terraform")
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "Lista de regras de saida (outbound) do Security Group."
  type = list(object({
    description = optional(string, "Regra de saida gerenciada via Terraform")
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
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
