provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Managed-By = "Terraform"
      },
      var.tags
    )
  }
}

locals {
  default_statements = [
    {
      effect    = "Allow"
      actions   = ["sts:GetCallerIdentity"]
      resources = ["*"]
      condition = []
    }
  ]

  effective_statements = length(var.policy_statements) > 0 ? var.policy_statements : local.default_statements
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = local.effective_statements
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = try(statement.value.condition, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
