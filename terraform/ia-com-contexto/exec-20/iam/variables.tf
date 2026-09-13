variable "environment" {
  description = "Ambiente de implantacao do recurso."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome curto do sistema ou produto ao qual o recurso pertence."
  type        = string
  default     = "tcc"

  validation {
    condition     = length(var.system) > 0
    error_message = "O valor de system nao pode ser vazio."
  }
}

variable "region" {
  description = "Regiao AWS onde o recurso sera criado."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.region) > 0
    error_message = "O valor de region nao pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem mescladas com as tags obrigatorias do recurso."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade da IAM Policy, utilizada como sufixo no padrao de nomenclatura <ambiente>-<sistema>-<recurso>-<finalidade>."
  type        = string
  default     = "readonly"

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "O valor de policy_name nao pode ser vazio."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform."
}

variable "allowed_actions" {
  description = "Lista de actions IAM permitidas na statement Allow da policy."
  type        = list(string)
  default     = ["s3:GetObject"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter pelo menos uma action."
  }
}

variable "allowed_resources" {
  description = "Lista de recursos (ARNs) permitidos na statement Allow da policy."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter pelo menos um recurso."
  }
}
