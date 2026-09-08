variable "region" {
  description = "Regiao AWS onde os recursos serao criados."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z-]+-\\d$", var.region))
    error_message = "Valor invalido para 'region'. Exemplo valido: us-east-1."
  }
}

variable "name" {
  description = "Nome do Security Group."
  type        = string
  default     = "sg-managed"

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255 && can(regex("^[A-Za-z0-9._\\- ]+$", var.name))
    error_message = "O nome deve ter entre 1 e 255 caracteres e conter apenas letras, numeros, espacos, ponto, underscore e hifen."
  }
}

variable "description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Security Group gerenciado pelo Terraform"

  validation {
    condition     = length(var.description) > 0 && length(var.description) <= 255
    error_message = "A descricao deve ter entre 1 e 255 caracteres."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado (nao usar VPC padrao)."
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id invalido. Formato esperado: vpc-xxxxxxxx ou vpc-xxxxxxxxxxxxxxxxx (hex)."
  }
}

variable "revoke_rules_on_delete" {
  description = "Se verdadeiro, revoga regras automaticamente antes da delecao do Security Group."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = <<EOT
Lista de regras de ingress (entrada). Cada item pode conter:
- description (string)
- from_port (number)
- to_port (number)
- protocol (string; ex: tcp, udp, icmp, -1)
- cidr_blocks (list(string))
- ipv6_cidr_blocks (list(string))
- prefix_list_ids (list(string))
- security_groups (list(string))
- self (bool)

Exemplo de item:
{
  description      = "SSH"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["203.0.113.0/24"]
  ipv6_cidr_blocks = []
  security_groups  = []
  self             = false
}
EOT
  type    = list(any)
  default = []
}

variable "egress_rules" {
  description = <<EOT
Lista de regras de egress (saida). Mesmo formato de ingress_rules.
Por padrao permite todo trafego de saida (IPv4 e IPv6).
EOT
  type = list(any)
  default = [
    {
      description      = "Allow all egress IPv4"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow all egress IPv6"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = []
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

variable "tags" {
  description = "Mapa de tags a serem aplicadas aos recursos."
  type        = map(string)
  default     = {}
}
