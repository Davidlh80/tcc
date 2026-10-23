variable "environment" {
  description = "Ambiente de implantação"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags extras aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}

variable "security_group_name" {
  description = "Nome do Security Group"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "allowed_ports" {
  description = "Lista de portas TCP liberadas na entrada"
  type        = list(number)
}

variable "allowed_cidrs" {
  description = "Lista de faixas de IP (CIDR) autorizadas na entrada"
  type        = list(string)
  validation {
    condition     = !contains(var.allowed_cidrs, "0.0.0.0/0")
    error_message = "Não é permitido liberar 0.0.0.0/0 na entrada; use faixas de IP específicas."
  }
}

variable "egress_cidrs" {
  description = "Faixas de IP (CIDR) de destino liberadas na saída"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
