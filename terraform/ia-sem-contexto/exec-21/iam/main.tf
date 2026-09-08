provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  # Base statement (optional, enabled by default)
  dynamic "statement" {
    for_each = var.include_base_statement ? [true] : []
    content {
      sid     = var.base_statement_sid
      effect  = var.effect
      actions = var.actions
      resources = var.resources

      dynamic "condition" {
        for_each = var.conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }

  # Additional statements (list)
  dynamic "statement" {
    for_each = var.additional_statements
    content {
      sid     = try(statement.value.sid, null)
      effect  = try(statement.value.effect, "Allow")
      actions = statement.value.actions
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
  # Use name_prefix when var.use_name_prefix = true to avoid collisions
  name        = var.use_name_prefix ? null : var.policy_name
  name_prefix = var.use_name_prefix ? var.policy_name : null

  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags

  lifecycle {
    precondition {
      condition     = var.include_base_statement || length(var.additional_statements) > 0
      error_message = "A policy must contain at least one statement. Enable include_base_statement or provide additional_statements."
    }
  }
}
