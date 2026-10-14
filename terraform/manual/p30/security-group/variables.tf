variable "environment" {
  description = "Ambiente usado nos nomes e nas tags dos security groups."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificador do sistema usado nos nomes dos security groups."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.system)) && length(var.system) <= 230
    error_message = "system deve conter até 230 caracteres minúsculos, números ou hífens, sem hífen inicial ou final."
  }
}

variable "region" {
  description = "Região AWS usada pelo provider."
  type        = string

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region não pode ser vazia."
  }
}

variable "additional_tags" {
  description = "Tags adicionais opcionais. Tags obrigatórias não podem ser sobrescritas."
  type        = map(string)
  default     = {}
}

variable "security_group_purposes" {
  description = "Finalidades dos security groups backend, rds e redis."
  type = object({
    backend = string
    rds     = string
    redis   = string
  })

  validation {
    condition = var.security_group_purposes.backend == "backend" && var.security_group_purposes.rds == "rds" && var.security_group_purposes.redis == "redis"
    error_message = "As finalidades devem ser backend, rds e redis para manter a arquitetura e a nomenclatura padronizadas."
  }
}

variable "vpc_id" {
  description = "ID da VPC onde os security groups serão criados."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]{8}([0-9a-fA-F]{9})?$", var.vpc_id))
    error_message = "vpc_id deve usar o formato AWS vpc- seguido de 8 ou 17 caracteres hexadecimais."
  }
}

variable "owner" {
  description = "Responsável exigido pela tag organizacional Owner."
  type        = string

  validation {
    condition     = var.owner == "devops"
    error_message = "owner deve ser devops, conforme o contexto organizacional."
  }
}

variable "required_tags" {
  description = "Tags obrigatórias de valor fixo definidas pelo padrão organizacional."
  type        = map(string)
  default = {
    Project    = "tcc-iac-ia"
    ManagedBy  = "terraform"
    CostCenter = "academic-research"
  }

  validation {
    condition = contains(keys(var.required_tags), "Project") && contains(keys(var.required_tags), "ManagedBy") && contains(keys(var.required_tags), "CostCenter") && var.required_tags.Project == "tcc-iac-ia" && var.required_tags.ManagedBy == "terraform" && var.required_tags.CostCenter == "academic-research"
    error_message = "required_tags deve conter Project, ManagedBy e CostCenter com os valores organizacionais definidos."
  }
}

variable "http_ingress_cidrs" {
  description = "CIDRs autorizados a acessar HTTP no backend; vazio por padrão para não expor a porta 80 publicamente."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.http_ingress_cidrs : can(cidrnetmask(cidr)) && cidr != "0.0.0.0/0"])
    error_message = "Cada item de http_ingress_cidrs deve ser um CIDR válido e não pode ser 0.0.0.0/0."
  }
}

variable "https_ingress_cidrs" {
  description = "CIDRs autorizados a acessar HTTPS no backend."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.https_ingress_cidrs : can(cidrnetmask(cidr))])
    error_message = "Cada item de https_ingress_cidrs deve ser um CIDR válido."
  }
}

variable "ssh_cidrs" {
  description = "CIDRs IPv4 /32 autorizados a acessar SSH no backend; uma lista vazia desativa o SSH."
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.ssh_cidrs :
      can(cidrnetmask(cidr)) && can(cidrhost(cidr, 0)) && endswith(cidr, "/32") && cidr != "0.0.0.0/0"
    ])
    error_message = "Cada item de ssh_cidrs deve ser um CIDR IPv4 /32 válido e não pode ser 0.0.0.0/0."
  }
}

variable "https_egress_cidrs" {
  description = "CIDRs autorizados para egress HTTPS do backend."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.https_egress_cidrs : can(cidrnetmask(cidr))])
    error_message = "Cada item de https_egress_cidrs deve ser um CIDR válido."
  }
}

variable "rds_port" {
  description = "Porta TCP usada pelo banco relacional."
  type        = number
  default     = 5432

  validation {
    condition     = var.rds_port >= 1 && var.rds_port <= 65535 && floor(var.rds_port) == var.rds_port
    error_message = "rds_port deve ser um inteiro entre 1 e 65535."
  }
}

variable "redis_port" {
  description = "Porta TCP usada pelo cache Redis."
  type        = number
  default     = 6379

  validation {
    condition     = var.redis_port >= 1 && var.redis_port <= 65535 && floor(var.redis_port) == var.redis_port
    error_message = "redis_port deve ser um inteiro entre 1 e 65535."
  }
}

variable "manage_default_security_group" {
  description = "Quando true, remove as regras do security group default da VPC ao gerenciá-lo."
  type        = bool
  default     = true
}
