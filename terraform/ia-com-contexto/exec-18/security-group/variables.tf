variable "region" {
  description = "Região AWS para provisionamento."
  type        = string

  validation {
    condition     = length(trim(var.region)) > 0
    error_message = "A variável 'region' não pode ser vazia."
  }
}

variable "environment" {
  description = "Ambiente de implantação. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O 'environment' deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicação (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "A variável 'system' deve conter apenas caracteres [a-z0-9-] e não pode ser vazia."
  }
}

variable "security_group_name" {
  description = "Nome/finalidade do Security Group (minúsculas, números e hífens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(var.security_group_name) > 0
    error_message = "A variável 'security_group_name' deve conter apenas caracteres [a-z0-9-] e não pode ser vazia."
  }
}

variable "security_group_description" {
  description = "Descrição do Security Group."
  type        = string
  default     = "Security Group gerenciado por Terraform para o sistema ${var.system}"
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado."
  type        = string

  validation {
    condition     = length(trim(var.vpc_id)) > 0
    error_message = "A variável 'vpc_id' não pode ser vazia."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group."
  type = list(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = []

  # Descrição obrigatória em toda regra
  validation {
    condition     = length([for r in var.ingress_rules : r.description if trim(r.description) == ""]) == 0
    error_message = "Todas as regras de entrada devem possuir 'description' preenchida."
  }

  # Portas válidas
  validation {
    condition = length([
      for r in var.ingress_rules : r
      if r.from_port < 0 || r.to_port > 65535 || r.to_port < r.from_port
    ]) == 0
    error_message = "Regras de entrada devem ter portas entre 0 e 65535, e to_port >= from_port."
  }

  # Pelo menos um destino em cada regra
  validation {
    condition     = length([for r in var.ingress_rules : r if length(r.cidr_blocks) == 0]) == 0
    error_message = "Cada regra de entrada deve possuir pelo menos um CIDR em 'cidr_blocks'."
  }

  # Proibição de 0.0.0.0/0 exceto 443/tcp
  validation {
    condition = length(flatten([
      for r in var.ingress_rules : [
        for c in r.cidr_blocks :
        c
        if c == "0.0.0.0/0" && !(lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      ]
    ])) == 0
    error_message = "Ingress: 0.0.0.0/0 é permitido apenas para 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saída do Security Group."
  type = list(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = []

  # Descrição obrigatória em toda regra
  validation {
    condition     = length([for r in var.egress_rules : r.description if trim(r.description) == ""]) == 0
    error_message = "Todas as regras de saída devem possuir 'description' preenchida."
  }

  # Portas válidas
  validation {
    condition = length([
      for r in var.egress_rules : r
      if r.from_port < 0 || r.to_port > 65535 || r.to_port < r.from_port
    ]) == 0
    error_message = "Regras de saída devem ter portas entre 0 e 65535, e to_port >= from_port."
  }

  # Pelo menos um destino em cada regra
  validation {
    condition     = length([for r in var.egress_rules : r if length(r.cidr_blocks) == 0]) == 0
    error_message = "Cada regra de saída deve possuir pelo menos um CIDR em 'cidr_blocks'."
  }

  # Proibição de 0.0.0.0/0 exceto 443/tcp
  validation {
    condition = length(flatten([
      for r in var.egress_rules : [
        for c in r.cidr_blocks :
        c
        if c == "0.0.0.0/0" && !(lower(r.protocol) == "tcp" && r.from_port == 443 && r.to_port == 443)
      ]
    ])) == 0
    error_message = "Egress: 0.0.0.0/0 é permitido apenas para 443/tcp."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatórias."
  type        = map(string)
  default     = {}
}
