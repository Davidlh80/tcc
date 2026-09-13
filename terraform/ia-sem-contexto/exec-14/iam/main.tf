data "aws_iam_policy_document" "this" {
  statement {
    sid       = "PolicyStatement"
    effect    = var.effect
    actions   = var.actions
    resources = var.resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.path
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
