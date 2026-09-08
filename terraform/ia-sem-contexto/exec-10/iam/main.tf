provider "aws" {
  region = var.aws_region
}

locals {
  # If a raw JSON policy is provided, we won't build a document from statements.
  effective_statements = var.policy_json != null ? [] : var.policy_statements

  statements_with_sid = [
    for s in local.effective_statements :
    s if trimspace(tostring(lookup(s, "sid", ""))) != ""
  ]

  statements_without_sid = [
    for s in local.effective_statements :
    s if trimspace(tostring(lookup(s, "sid", ""))) == ""
  ]
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = local.statements_with_sid
    content {
      sid    = trimspace(tostring(lookup(statement.value, "sid", "")))
      effect = lookup(statement.value, "effect", "Allow")

      actions   = lookup(statement.value, "actions", [])
      resources = lookup(statement.value, "resources", [])

      dynamic "condition" {
        for_each = try(lookup(statement.value, "conditions", []), [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }

  dynamic "statement" {
    for_each = local.statements_without_sid
    content {
      effect = lookup(statement.value, "effect", "Allow")

      actions   = lookup(statement.value, "actions", [])
      resources = lookup(statement.value, "resources", [])

      dynamic "condition" {
        for_each = try(lookup(statement.value, "conditions", []), [])
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
  path        = var.policy_path
  description = var.policy_description

  policy = var.policy_json != null ? var.policy_json : data.aws_iam_policy_document.this.json

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.policy_json == null || can(jsondecode(var.policy_json))
      error_message = "policy_json deve ser um JSON válido."
    }
    precondition {
      condition     = var.policy_json != null || length(local.effective_statements) > 0
      error_message = "Forneça policy_json ou ao menos um item em policy_statements."
    }
  }
}
