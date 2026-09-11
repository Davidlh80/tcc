variable "environment" {
  description = "Ambiente da implantacao (dev, hml, prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/aplicacao (ex.: tcc)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(trimspace(var.system)) > 0
    error_message = "system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  description = "Regiao AWS para o provisionamento."
  type        = string

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region nao pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Mapa de tags adicionais a serem aplicadas ao recurso."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "vpc_id nao pode ser vazio."
  }
}

variable "security_group_name" {
  description = "Nome/finalidade do Security Group (segmento final do padrao <env>-<sistema>-sg-<finalidade>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.security_group_name)) && length(trimspace(var.security_group_name)) > 0
    error_message = "security_group_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "security_group_description" {
  description = "Descricao do Security Group."
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "Lista de regras de entrada. Cada regra deve conter descricao e alvos. 0.0.0.0/0 (ou ::/0) so e permitido para tcp/443 exatamente."
  type = list(object({
    description                = string
    protocol                   = string
    from_port                  = number
    to_port                    = number
    cidr_blocks                = optional(list(string), [])
    ipv6_cidr_blocks           = optional(list(string), [])
    source_security_group_ids  = optional(list(string), [])
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.ingress_rules : length(trimspace(r.description)) > 0])
    error_message = "Todas as regras de ingress devem ter 'description' nao vazio."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      (
        r.protocol == "-1"
        ? (r.from_port == 0 && r.to_port == 0)
        : (r.from_port >= 0 && r.to_port <= 65535 && r.to_port >= r.from_port)
      )
    ])
    error_message = "Ingress: intervalos de portas invalidos. Para protocolo '-1' use from_port=0 e to_port=0; caso contrario use 0-65535 com to_port >= from_port."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      length(lookup(r, "cidr_blocks", [])) + length(lookup(r, "ipv6_cidr_blocks", [])) + length(lookup(r, "source_security_group_ids", [])) > 0
    ])
    error_message = "Cada regra de ingress deve especificar pelo menos um destino: cidr_blocks, ipv6_cidr_blocks ou source_security_group_ids."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      alltrue([for c in lookup(r, "cidr_blocks", []) : c != "0.0.0.0/0" ? true : (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)])
    ])
    error_message = "Ingress: nao e permitido 0.0.0.0/0 exceto exatamente para tcp/443."
  }

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      alltrue([for c in lookup(r, "ipv6_cidr_blocks", []) : c != "::/0" ? true : (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)])
    ])
    error_message = "Ingress: nao e permitido ::/0 exceto exatamente para tcp/443."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida (egress). Egress deve ser explicito; nao permitir liberacao irrestrita. 0.0.0.0/0 (ou ::/0) so e permitido para tcp/443 exatamente."
  type = list(object({
    description                = string
    protocol                   = string
    from_port                  = number
    to_port                    = number
    cidr_blocks                = optional(list(string), [])
    ipv6_cidr_blocks           = optional(list(string), [])
    source_security_group_ids  = optional(list(string), [])
  }))

  validation {
    condition     = length(var.egress_rules) > 0
    error_message = "Deve haver pelo menos uma regra de egress explicita para evitar liberacao irrestrita por padrao."
  }

  validation {
    condition     = alltrue([for r in var.egress_rules : length(trimspace(r.description)) > 0])
    error_message = "Todas as regras de egress devem ter 'description' nao vazio."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      (
        r.protocol == "-1"
        ? (r.from_port == 0 && r.to_port == 0)
        : (r.from_port >= 0 && r.to_port <= 65535 && r.to_port >= r.from_port)
      )
    ])
    error_message = "Egress: intervalos de portas invalidos. Para protocolo '-1' use from_port=0 e to_port=0; caso contrario use 0-65535 com to_port >= from_port."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      length(lookup(r, "cidr_blocks", [])) + length(lookup(r, "ipv6_cidr_blocks", [])) + length(lookup(r, "source_security_group_ids", [])) > 0
    ])
    error_message = "Cada regra de egress deve especificar pelo menos um destino: cidr_blocks, ipv6_cidr_blocks ou source_security_group_ids."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      alltrue([for c in lookup(r, "cidr_blocks", []) : c != "0.0.0.0/0" ? true : (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)])
    ])
    error_message = "Egress: nao e permitido 0.0.0.0/0 exceto exatamente para tcp/443."
  }

  validation {
    condition = alltrue([
      for r in var.egress_rules :
      alltrue([for c in lookup(r, "ipv6_cidr_blocks", []) : c != "::/0" ? true : (r.protocol == "tcp" && r.from_port == 443 && r.to_port == 443)])
    ])
    error_message = "Egress: nao e permitido ::/0 exceto exatamente para tcp/443."
  }
}
