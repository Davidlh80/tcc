provider "aws" {
  region = var.aws_region
}

locals {
  # Default and user-provided tags are merged, with user tags taking precedence
  effective_tags = merge(
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
      sid           = try(statement.value.sid, null)
      effect        = try(statement.value.effect, "Allow")
      actions       = length(try(statement.value.actions, [])) > 0 ? statement.value.actions : null
      not_actions   = length(try(statement.value.not_actions, [])) > 0 ? statement.value.not_actions : null
      resources     = length(try(statement.value.resources, [])) > 0 ? statement.value.resources : null
      not_resources = length(try(statement.value.not_resources, [])) > 0 ? statement.value.not_resources : null

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
  name        = var.name != "" ? var.name : null
  name_prefix = var.name == "" ? var.name_prefix : null
  description = var.description
  path        = var.path
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.effective_tags
}
