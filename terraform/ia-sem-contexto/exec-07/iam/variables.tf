variable "aws_region" {
  description = "Regiao AWS a ser usada pelo provider."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(trim(var.aws_region)) > 0
    error_message = "aws_region nao pode ser vazio."
  }
}

variable "policy_name" {
  description = "Nome da IAM Policy a ser criada."
  type        = string
  default     = "custom-iam-policy"

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", var.policy_name))
    error_message = "policy_name deve conter apenas os caracteres permitidos por IAM e ter entre 1 e 128 caracteres."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Custom IAM policy gerenciada por Terraform."
}

variable "policy_path" {
  description = "Caminho (path) da IAM Policy. Deve iniciar e terminar com '/'. Use '/' para o padrao."
  type        = string
  default     = "/"

  validation {
    condition     = var.policy_path == "/" || can(regex("^/.+/$", var.policy_path))
    error_message = "policy_path deve ser '/' ou um caminho que inicie e termine com '/'."
  }
}

variable "policy_json" {
  description = "Documento JSON da policy (string). Se nulo ou vazio, uma policy segura e de leitura sera aplicada por padrao."
  type        = string
  default     = null

  validation {
    condition     = var.policy_json == null || trim(var.policy_json) == "" || can(jsondecode(var.policy_json))
    error_message = "policy_json deve ser uma string JSON valida ou nula/vazia."
  }
}

variable "enable_attachments" {
  description = "Se true, cria um anexo unico da policy para usuarios, roles e/ou grupos especificados."
  type        = bool
  default     = false

  validation {
    condition     = var.enable_attachments == false || (length(var.attach_users) + length(var.attach_roles) + length(var.attach_groups) > 0)
    error_message = "Quando enable_attachments=true, forneca ao menos um usuario, role ou grupo."
  }
}

variable "attach_users" {
  description = "Lista de nomes de usuarios IAM para anexar a policy (opcional)."
  type        = list(string)
  default     = []
}

variable "attach_roles" {
  description = "Lista de nomes de roles IAM para anexar a policy (opcional)."
  type        = list(string)
  default     = []
}

variable "attach_groups" {
  description = "Lista de nomes de grupos IAM para anexar a policy (opcional)."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags adicionais a aplicar na IAM Policy."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.tags) : !startswith(lower(k), "aws:")])
    error_message = "Chaves de tags nao podem comecar com 'aws:'."
  }
}
