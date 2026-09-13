data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.statements

    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = statement.value.conditions

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
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags

  lifecycle {
    precondition {
      condition     = var.allow_wildcard_actions || alltrue([for s in var.statements : !contains(s.actions, "*")])
      error_message = "Acoes com wildcard total ('*') nao sao permitidas a menos que var.allow_wildcard_actions seja definido como true."
    }
  }
}
