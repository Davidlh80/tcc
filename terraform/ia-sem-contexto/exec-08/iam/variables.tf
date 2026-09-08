variable "aws_region" {
  description = "Regiao AWS para o provider."
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region deve estar no formato ex: us-east-1."
  }
}

variable "policy_name" {
  description = "Nome amigavel da IAM Policy (1-128 chars, A-Za-z0-9+=,.@_-)."
  type        = string
  default     = "custom-managed-policy"
  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter somente A-Za-z0-9+=,.@_- e ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Managed IAM Policy provisionada via Terraform."
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve iniciar e terminar com '/'."
  type        = string
  default     = "/"
  validation {
    condition     = can(regex("^(/|(/[\\w+=,.@-]+/)+)$", var.policy_path))
    error_message = "policy_path deve ser '/' ou no formato '/segmento1/segmento2/.../'."
  }
}

variable "tags" {
  description = "Tags a serem aplicadas na IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

variable "policy_document_json" {
  description = "Documento JSON completo da IAM Policy (opcional). Se vazio, sera gerado um documento padrao a partir de default_actions e default_resources."
  type        = string
  default     = ""
}

variable "policy_sid" {
  description = "SID para o statement padrao quando policy_document_json nao for fornecido."
  type        = string
  default     = "DefaultAllow"
  validation {
    condition     = can(regex("^[A-Za-z0-9]{1,128}$", var.policy_sid))
    error_message = "policy_sid deve conter apenas letras e numeros (1-128)."
  }
}

variable "default_actions" {
  description = "Acoes permitidas no statement padrao quando policy_document_json nao for fornecido."
  type        = list(string)
  default     = ["sts:GetCallerIdentity"]
  validation {
    condition     = length([for a in var.default_actions : a if trim(a) == ""]) == 0 && length(var.default_actions) > 0
    error_message = "default_actions deve conter pelo menos uma acao valida e nenhuma acao vazia."
  }
}

variable "default_resources" {
  description = "Recursos para o statement padrao quando policy_document_json nao for fornecido."
  type        = list(string)
  default     = ["*"]
  validation {
    condition     = length([for r in var.default_resources : r if trim(r) == ""]) == 0 && length(var.default_resources) > 0
    error_message = "default_resources deve conter pelo menos um recurso valido e nenhum item vazio."
  }
}

variable "attach_to_roles" {
  description = "Conjunto de nomes de IAM Roles aos quais anexar esta policy (opcional)."
  type        = set(string)
  default     = []
}

variable "attach_to_users" {
  description = "Conjunto de nomes de IAM Users aos quais anexar esta policy (opcional)."
  type        = set(string)
  default     = []
}

variable "attach_to_groups" {
  description = "Conjunto de nomes de IAM Groups aos quais anexar esta policy (opcional)."
  type        = set(string)
  default     = []
}
