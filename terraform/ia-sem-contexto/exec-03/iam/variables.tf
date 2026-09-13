variable "aws_region" {
  description = "Regiao AWS onde o provider ira operar."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy. Deve seguir o padrao aceito pela AWS (1-128 caracteres, letras, numeros e + = , . @ - _)."
  type        = string
  default     = "example-least-privilege-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "O nome da policy deve ter entre 1 e 128 caracteres validos para IAM (letras, numeros, + = , . @ - _)."
  }
}

variable "description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform seguindo o principio do menor privilegio."
}

variable "path" {
  description = "Path da IAM Policy dentro da conta AWS."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.path))
    error_message = "O path deve comecar e terminar com '/', por exemplo '/' ou '/times/plataforma/'."
  }
}

variable "effect" {
  description = "Efeito da statement da policy (Allow ou Deny)."
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.effect)
    error_message = "O valor de effect deve ser 'Allow' ou 'Deny'."
  }
}

variable "actions" {
  description = "Lista de actions IAM permitidas/negadas pela policy. Nao utilize '*' isolado; prefira wildcards de servico especifico (ex: 's3:Get*')."
  type        = list(string)
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.actions) > 0 && !contains(var.actions, "*")
    error_message = "Informe ao menos uma action e evite o uso de '*' isolado como action, para manter o menor privilegio."
  }
}

variable "resources" {
  description = "Lista de ARNs de recursos aos quais a policy se aplica. Nao utilize '*' isolado; especifique ARNs concretos."
  type        = list(string)
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.resources) > 0 && !contains(var.resources, "*")
    error_message = "Informe ao menos um ARN de recurso e evite o uso de '*' isolado, para manter o menor privilegio."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Policy."
  type        = map(string)
  default     = {}
}
