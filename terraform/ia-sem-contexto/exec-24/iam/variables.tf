variable "aws_region" {
  description = "Regiao AWS onde a policy sera provisionada (IAM e global, mas o provider exige uma regiao)."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "least-privilege-example-policy"
}

variable "policy_description" {
  description = "Descricao da IAM Policy."
  type        = string
  default     = "Policy de exemplo com permissoes minimas, gerada como blueprint Terraform."
}

variable "policy_path" {
  description = "Path da IAM Policy dentro da conta AWS."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags aplicadas a IAM Policy."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}

variable "statements" {
  description = "Lista de statements IAM (sid, effect, actions, resources) que compoem o documento da policy. Evite usar '*' em actions ou resources em ambientes produtivos."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))

  default = [
    {
      sid       = "AllowS3ReadOnlyExample"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::REPLACE_WITH_BUCKET_NAME",
        "arn:aws:s3:::REPLACE_WITH_BUCKET_NAME/*"
      ]
    }
  ]
}
