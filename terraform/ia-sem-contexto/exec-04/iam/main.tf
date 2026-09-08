provider "aws" {
  region = var.region
}

locals {
  statements = [
    for s in var.statements : merge(
      {
        Effect   = s.effect
        Action   = sort([for a in s.actions : a])
        Resource = sort([for r in s.resources : r])
      },
      s.sid != null && s.sid != "" ? { Sid = s.sid } : {},
      (try(length(s.conditions), 0) > 0) ? { Condition = s.conditions } : {}
    )
  ]

  policy_doc = {
    Version   = "2012-10-17"
    Statement = local.statements
  }

  tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

resource "aws_iam_policy" "this" {
  name_prefix = var.policy_name_prefix
  path        = var.path
  description = var.description
  policy      = jsonencode(local.policy_doc)
  tags        = local.tags

  lifecycle {
    precondition {
      condition   = length(var.statements) > 0
      description = "Pelo menos um statement deve ser fornecido em var.statements."
    }
  }
}
