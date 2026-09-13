data "aws_iam_policy_document" "this" {
  statement {
    sid       = var.sid
    effect    = var.effect
    actions   = var.actions
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

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
