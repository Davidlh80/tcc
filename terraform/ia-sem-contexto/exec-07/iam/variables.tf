variable "aws_region" {
  description = "Regiao AWS onde o provider sera configurado."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-readonly-policy"

  validation {
    condition     = can(regex("^[\\w+=,.@-]{1,128}$", var.policy_name))
    error_message = "O nome deve ter entre 1 e 128 caracteres validos para IAM (letras, numeros e os simbolos + = , . @ _ -)."
  }
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy gerenciada via Terraform com permissoes minimas de leitura em um recurso S3 especifico."
}

variable "policy_path" {
  description = "Path da IAM Policy dentro do IAM."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

variable "statements" {
  description = "Lista de statements (Allow/Deny) que compoem o documento da IAM Policy. O default aplica permissoes de leitura restritas a um unico bucket S3, sem uso de wildcard em recursos."
  type = list(object({
    sid    = optional(string)
    effect = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))

  default = [
    {
      sid       = "AllowReadOnlyExampleBucket"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::example-bucket",
        "arn:aws:s3:::example-bucket/*"
      ]
    }
  ]
}
