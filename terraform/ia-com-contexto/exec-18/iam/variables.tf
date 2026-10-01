variable "environment" {
  type        = string
  description = "Ambiente de implantacao dos recursos."

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "O valor de environment deve ser um dos seguintes: dev, hml, prd."
  }
}

variable "system" {
  type        = string
  description = "Nome do sistema ou aplicacao ao qual os recursos de IAM pertencem."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system))
    error_message = "O valor de system deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "region" {
  type        = string
  description = "Regiao AWS utilizada pelo provider."
  default     = "us-east-1"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags adicionais a serem mescladas com as tags obrigatorias da organizacao."
  default     = {}
}

variable "policy_name" {
  type        = string
  description = "Finalidade/sufixo que identifica a IAM Policy e a IAM Role (ex.: readonly, logs-access)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "O valor de policy_name deve conter apenas letras minusculas, numeros e hifens."
  }
}

variable "trusted_principal_arn" {
  type        = string
  description = "ARN do unico principal IAM (usuario, role ou conta) autorizado a assumir a Role. Nao pode ser '*'."

  validation {
    condition     = var.trusted_principal_arn != "*" && can(regex("^arn:aws[a-zA-Z-]*:iam::", var.trusted_principal_arn))
    error_message = "trusted_principal_arn deve ser um ARN de principal IAM valido e nao pode ser '*'."
  }
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas (Effect Allow) na policy."

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }
}

variable "allowed_resources" {
  type        = list(string)
  description = "Lista de recursos (ARNs) permitidos (Effect Allow) na policy."

  validation {
    condition     = length(var.allowed_resources) > 0
    error_message = "allowed_resources deve conter ao menos um recurso."
  }
}
