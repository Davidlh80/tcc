provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = var.statement_sid
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
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
