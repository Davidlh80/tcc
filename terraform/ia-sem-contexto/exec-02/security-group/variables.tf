variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado. Deve ser a VPC provisionada pelo ambiente de teste, nao a VPC default da conta."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "O valor de vpc_id deve ser um ID de VPC valido, iniciando com \"vpc-\"."
  }
}

variable "name" {
  description = "Nome atribuido ao Security Group."
  type        = string
  default     = "app-sg"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada explicitas. Nenhuma regra e criada por padrao; defina apenas as portas e origens estritamente necessarias."
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
  description = "Lista de regras de saida explicitas. Nenhuma regra e criada por padrao; defina apenas os destinos estritamente necessarios."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Mapa de tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
