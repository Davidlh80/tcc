provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.statements
    content {
      sid       = try(statement.value.sid, null)
      effect    = upper(try(statement.value.effect, "Allow"))
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])
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
  name_prefix = var.policy_name_prefix
  description = var.policy_description
  path        = var.path
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.common_tags
}
