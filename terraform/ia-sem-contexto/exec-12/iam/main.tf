provider "aws" {
  region = var.aws_region
}

locals {
  tags = merge(
    {
      "Name"      = var.name
      "ManagedBy" = "Terraform"
    },
    var.tags
  )
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.statements

    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = statement.value.condition

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
  name        = var.name
  path        = var.path
  description = var.description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags
}
