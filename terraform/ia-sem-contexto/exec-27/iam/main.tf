provider "aws" {
  region = var.region
}

locals {
  default_tags = {
    ManagedBy   = "Terraform"
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"

  dynamic "statement" {
    for_each = var.statements
    content {
      sid       = statement.value.sid != "" ? statement.value.sid : null
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = lookup(statement.value, "conditions", [])
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

  tags = merge(local.default_tags, var.tags)
}
