provider "aws" {
  region = var.region
}

locals {
  # Determine whether to use a raw JSON policy provided by the user
  use_custom_json = var.policy_json != null && trim(var.policy_json) != ""

  # Default least-privilege, read-only statement if no statements are provided
  default_statements = [
    {
      sid       = "ReadAccountSummary"
      effect    = "Allow"
      actions   = ["iam:GetAccountSummary"]
      resources = ["*"]
    }
  ]

  # Effective statements (user-provided or default)
  eff_statements = var.statements != null && length(var.statements) > 0 ? var.statements : local.default_statements

  # Map statements to indexes so we can generate unique SIDs when not provided
  statement_map = { for idx, s in local.eff_statements : tostring(idx) => s }

  effective_policy_json = local.use_custom_json ? var.policy_json : data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  count = local.use_custom_json ? 0 : 1

  dynamic "statement" {
    for_each = local.statement_map
    content {
      # Ensure unique SID if not provided
      sid = try(statement.value.sid, "Stmt${statement.key}")

      # Normalize effect to "Allow" or "Deny"
      effect = lower(statement.value.effect) == "deny" ? "Deny" : "Allow"

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
  name        = var.name != null && trim(var.name) != "" ? var.name : null
  name_prefix = var.name == null || trim(var.name) == "" ? var.name_prefix : null
  path        = var.path
  description = var.description
  policy      = local.effective_policy_json
  tags        = var.tags
}
