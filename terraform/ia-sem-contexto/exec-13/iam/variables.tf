variable "aws_region" {
  type        = string
  description = "Regiao AWS utilizada pelo provider."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Nome da IAM Role a ser criada."
  default     = "app-restricted-role"
}

variable "role_description" {
  type        = string
  description = "Descricao da IAM Role."
  default     = "Role gerenciada via Terraform com trust policy restrita e permissoes minimas."
}

variable "role_path" {
  type        = string
  description = "Path da IAM Role (deve iniciar e terminar com \"/\")."
  default     = "/"

  validation {
    condition     = substr(var.role_path, 0, 1) == "/" && substr(var.role_path, -1, 1) == "/"
    error_message = "role_path deve iniciar e terminar com \"/\" (ex: \"/\" ou \"/app/\")."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Duracao maxima (em segundos) de uma sessao assumida pela role. Deve estar entre 3600 e 43200."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration deve estar entre 3600 e 43200 segundos."
  }
}

variable "trust_principal_type" {
  type        = string
  description = "Tipo do principal autorizado a assumir a role: AWS, Service ou Federated."
  default     = "AWS"

  validation {
    condition     = contains(["AWS", "Service", "Federated"], var.trust_principal_type)
    error_message = "trust_principal_type deve ser um dos valores: AWS, Service, Federated."
  }
}

variable "trust_principal_identifiers" {
  type        = list(string)
  description = "Lista de principals (ex: ARN de conta/role especifica, ou service principal como ec2.amazonaws.com) autorizados a assumir a role. Nao pode conter o wildcard \"*\"."
  default     = ["arn:aws:iam::123456789012:root"]

  validation {
    condition     = length(var.trust_principal_identifiers) > 0
    error_message = "trust_principal_identifiers deve conter ao menos um principal."
  }

  validation {
    condition     = alltrue([for p in var.trust_principal_identifiers : p != "*"])
    error_message = "trust_principal_identifiers nao pode conter o wildcard \"*\". Especifique contas, roles ou service principals explicitos."
  }
}

variable "policy_name" {
  type        = string
  description = "Nome da IAM Policy a ser criada e anexada a role."
  default     = "app-restricted-policy"
}

variable "policy_description" {
  type        = string
  description = "Descricao da IAM Policy."
  default     = "Policy gerenciada via Terraform com permissoes restritas a acoes e recursos especificos."
}

variable "allowed_actions" {
  type        = list(string)
  description = "Lista de acoes IAM permitidas pela policy. Nao pode conter o wildcard global \"*\" nem \"*:*\"."
  default     = ["s3:GetObject", "s3:ListBucket"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "allowed_actions deve conter ao menos uma acao."
  }

  validation {
    condition     = alltrue([for a in var.allowed_actions : a != "*" && a != "*:*"])
    error_message = "allowed_actions nao pode conter os wildcards \"*\" ou \"*:*\". Especifique acoes explicitas (ex: \"s3:GetObject\")."
  }
}

variable "resource_arns" {
  type        = list(string)
  description = "Lista de ARNs de recursos aos quais as acoes se aplicam. Nao pode conter o wildcard global \"*\"."
  default     = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]

  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "resource_arns deve conter ao menos um ARN."
  }

  validation {
    condition     = alltrue([for r in var.resource_arns : r != "*"])
    error_message = "resource_arns nao pode conter o wildcard global \"*\". Especifique ARNs explicitos ou padroes escopados (ex: \"arn:aws:s3:::bucket/*\")."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a role e a policy."
  default     = {}
}
