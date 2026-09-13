data "aws_iam_policy_document" "this" {
  statement {
    sid       = "CustomPolicyStatement"
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
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
