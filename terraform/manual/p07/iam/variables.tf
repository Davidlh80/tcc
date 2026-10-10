variable "region" {
  description = "Regiao AWS usada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da policy IAM."
  type        = string
}

variable "role_name" {
  description = "Nome da role IAM."
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, hml ou prd)."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser dev, hml ou prd."
  }
}

variable "trusted_service" {
  description = "Servico AWS que pode assumir a role (ex.: ec2.amazonaws.com)."
  type        = string
  default     = "ec2.amazonaws.com"

  validation {
    condition     = can(regex("^[a-z0-9-]+(\\.[a-z0-9-]+)*\\.amazonaws\\.com$", var.trusted_service))
    error_message = "trusted_service deve ser um servico AWS, por exemplo ec2.amazonaws.com."
  }
}

variable "allowed_actions" {
  description = "Acoes liberadas pela policy."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for a in var.allowed_actions : !strcontains(a, "*")])
    error_message = "Informe ao menos uma acao e nao use curinga (*)."
  }
}

variable "allowed_resources" {
  description = "ARNs dos recursos em que as acoes sao permitidas."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for r in var.allowed_resources : startswith(r, "arn:")])
    error_message = "Informe ao menos um ARN. O valor * nao e aceito."
  }
}

variable "additional_tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
