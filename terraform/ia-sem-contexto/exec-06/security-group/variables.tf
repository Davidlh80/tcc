variable "aws_region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "ID da VPC (criada pelo ambiente de teste) onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]+$", var.vpc_id))
    error_message = "O valor de vpc_id deve seguir o formato 'vpc-xxxxxxxx'."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-managed"
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security group gerenciado via Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Nenhuma regra e aplicada por padrao, evitando abertura irrestrita."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : contains(["tcp", "udp", "icmp", "-1"], r.protocol)])
    error_message = "O protocolo de cada regra de ingress deve ser um dos valores: tcp, udp, icmp, -1."
  }

  validation {
    condition     = alltrue([for r in var.ingress_rules : !contains(r.cidr_blocks, "0.0.0.0/0")])
    error_message = "Regras de ingress nao podem usar o CIDR 0.0.0.0/0. Defina origens especificas."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida. O padrao libera apenas HTTPS (443) para qualquer destino."
  type = list(object({
    description = string
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

  validation {
    condition     = alltrue([for r in var.egress_rules : contains(["tcp", "udp", "icmp", "-1"], r.protocol)])
    error_message = "O protocolo de cada regra de egress deve ser um dos valores: tcp, udp, icmp, -1."
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas ao Security Group."
  type        = map(string)
  default     = {}
}
