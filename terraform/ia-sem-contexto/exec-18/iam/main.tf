provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}

locals {
  normalized_statements = [
    for s in var.statements : merge(
      {
        Sid      = s.sid
        Effect   = upper(s.effect)
        Action   = s.actions
        Resource = s.resources
      },
      length(keys(s.condition)) > 0 ? { Condition = s.condition } : {}
    )
  ]

  policy_document_built = jsonencode({
    Version   = "2012-10-17"
    Statement = local.normalized_statements
  })

  policy_document = var.policy_json != null && trim(var.policy_json) != "" ? var.policy_json : local.policy_document_built
}

resource "aws_iam_policy" "this" {
  count       = var.create ? 1 : 0
  name        = var.policy_name
  description = var.policy_description
  path        = var.path
  policy      = local.policy_document
  tags        = var.tags

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}
