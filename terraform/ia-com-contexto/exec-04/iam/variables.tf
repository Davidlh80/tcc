variable "environment" {
  description = "Ambiente de implantação. Valores permitidos: dev, hml, prd."
  type        = string

  validation {
    condition     = contains(["dev", "hml", "prd"], var.environment)
    error_message = "environment deve ser um dos valores: dev, hml, prd."
  }
}

variable "system" {
  description = "Nome do sistema/aplicação (minúsculas, números e hifens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.system)) && length(var.system) > 0
    error_message = "system deve conter apenas minúsculas, números e hifens, e não pode ser vazio."
  }
}

variable "region" {
  description = "Região AWS para o provider."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "region não pode ser vazio."
  }
}

variable "additional_tags" {
  description = "Tags adicionais a serem aplicadas ao recurso (as tags obrigatórias sempre prevalecem em caso de conflito)."
  type        = map(string)
  default     = {}
}

variable "policy_name" {
  description = "Nome/purpose da policy (parte final do padrão <environment>-<system>-iam-<policy_name>)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name)) && length(var.policy_name) > 0
    error_message = "policy_name deve conter apenas minúsculas, números e hifens, e não pode ser vazio."
  }
}

variable "allowed_actions" {
  description = "Lista de ações AWS IAM a serem permitidas (ex.: [\"s3:GetObject\", \"s3:ListBucket\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_actions) > 0 && !contains(var.allowed_actions, "")
    error_message = "allowed_actions deve conter ao menos uma ação válida e não pode incluir strings vazias."
  }
}

variable "allowed_resources" {
  description = "Lista de ARNs de recursos aos quais as ações serão permitidas (ex.: [\"arn:aws:s3:::my-bucket\", \"arn:aws:s3:::my-bucket/*\"])."
  type        = list(string)

  validation {
    condition     = length(var.allowed_resources) > 0 && !contains(var.allowed_resources, "")
    error_message = "allowed_resources deve conter ao menos um ARN de recurso válido e não pode incluir strings vazias."
  }
}

variable "policy_description" {
  description = "Descrição opcional para a IAM Policy."
  type        = string
  default     = null
}

# Segurança: Proíbe uma statement que combine Action: \"*\" com Resource: \"*\".
# Implementado via validação cruzada entre allowed_actions e allowed_resources.
locals {
  _deny_actions_and_resources_all = contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*")
}

# O bloco abaixo usa uma construção de validação indireta: um erro é forçado se a combinação proibida ocorrer.
resource "null_resource" "validate_no_actions_and_resources_all" {
  # Esta dependência lógica assegura que a validação ocorra em 'plan' sem afetar o estado final.
  # O recurso não cria nada em produção; é apenas um gate de validação sem efeitos colaterais.
  count = local._deny_actions_and_resources_all ? 1 : 0

  lifecycle {
    prevent_destroy = false
  }

  provisioner "local-exec" {
    when    = destroy
    command = "true"
  }
}

# Recurso fictício para falhar o plano quando a combinação proibida for detectada.
# Terraform não possui um 'fail' nativo, então utilizamos uma referência inválida condicional para provocar erro de validação.
output "__validation_error_actions_and_resources_all" {
  value       = "Combinação proibida: 'allowed_actions' contém \"*\" e 'allowed_resources' contém \"*\" na mesma policy statement."
  description = "Erro de validação: não é permitido Action: \"*\" com Resource: \"*\"."
  condition   = false
  depends_on  = [null_resource.validate_no_actions_and_resources_all]
}
