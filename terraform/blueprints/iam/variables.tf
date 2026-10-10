variable "environment" {
  description = "Ambiente de implantacao."
  type        = string
  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "Use dev, hml ou prd."
  }
}

variable "system" {
  description = "Identificacao do sistema."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.system))
    error_message = "Use letras minusculas, numeros e hifens entre segmentos."
  }
}

variable "region" {
  description = "Regiao AWS."
  type        = string
  default     = "us-east-1"
}

variable "additional_tags" {
  description = "Tags adicionais; tags obrigatorias prevalecem."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Finalidade que compoe o nome."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.policy_name))
    error_message = "Use letras minusculas, numeros e hifens entre segmentos."
  }
}

variable "role_name" {
  description = "Finalidade que compoe o nome."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]+(-[a-z0-9]+)*$", var.role_name))
    error_message = "Use letras minusculas, numeros e hifens entre segmentos."
  }
}

variable "trusted_principal_arn" {
  description = "ARN unico do principal AWS autorizado a assumir a role."
  type        = string
  validation {
    condition     = can(regex("^arn:(aws|aws-us-gov|aws-cn):iam::[0-9]{12}:(role|user)/[^*?]+$", var.trusted_principal_arn))
    error_message = "Informe um ARN IAM de role ou usuario sem wildcard."
  }
}

variable "allowed_actions" {
  description = "Acoes especificas autorizadas."
  type        = list(string)
  validation {
    condition     = length(var.allowed_actions) > 0 && alltrue([for action in var.allowed_actions : can(regex("^[a-z0-9-]+:[A-Za-z0-9]+$", action))])
    error_message = "Informe acoes no formato servico:Acao, sem wildcard."
  }
}

variable "allowed_resources" {
  description = "ARNs autorizados; wildcard apenas no sufixo de um recurso delimitado."
  type        = list(string)
  validation {
    condition     = length(var.allowed_resources) > 0 && alltrue([for arn in var.allowed_resources : can(regex("^arn:(aws|aws-us-gov|aws-cn):[a-z0-9-]+:[^*?]*:[^*?]*:[^*?]+\\*?$", arn))])
    error_message = "Informe ARNs delimitados, com wildcard opcional apenas no final."
  }
}
