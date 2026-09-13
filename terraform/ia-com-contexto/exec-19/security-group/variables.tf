variable "environment" {
  description = "Ambiente de implantacao do recurso. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Identificador do sistema/produto ao qual o recurso pertence (usado na nomenclatura padrao)."
  type        = string

  validation {
    condition     = length(trimspace(var.system)) > 0
    error_message = "system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera criado."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group sera criado."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "vpc_id deve ser um ID de VPC valido (ex: vpc-0123456789abcdef0)."
  }
}

variable "security_group_name" {
  description = "Finalidade do Security Group, utilizada como sufixo na nomenclatura padrao (ex: web, database, app)."
  type        = string

  validation {
    condition     = length(trimspace(var.security_group_name)) > 0
    error_message = "security_group_name nao pode ser vazio."
  }
}

variable "security_group_description" {
  description = "Descricao do Security Group, exibida no console AWS."
  type        = string
  default     = "Security group gerenciado via Terraform."

  validation {
    condition     = length(trimspace(var.security_group_description)) > 0
    error_message = "security_group_description nao pode ser vazio."
  }
}

variable "ingress_rules" {
  description = "Lista de regras de entrada do Security Group. 0.0.0.0/0 somente e permitido para a porta 443/tcp. Toda regra deve conter descricao."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de ingress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
    ])
    error_message = "0.0.0.0/0 so e permitido em regras de ingress para a porta 443/tcp."
  }
}

variable "egress_rules" {
  description = "Lista de regras de saida do Security Group, declaradas explicitamente. 0.0.0.0/0 somente e permitido para a porta 443/tcp. Toda regra deve conter descricao."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    {
      description = "Permite trafego de saida HTTPS (443/tcp) para integracoes e atualizacoes externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules : length(trimspace(rule.description)) > 0
    ])
    error_message = "Toda regra de egress deve conter uma descricao nao vazia."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      !contains(rule.cidr_blocks, "0.0.0.0/0") || (rule.from_port == 443 && rule.to_port == 443 && rule.protocol == "tcp")
    ])
    error_message = "0.0.0.0/0 so e permitido em regras de egress para a porta 443/tcp."
  }
}
