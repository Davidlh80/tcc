data "aws_iam_policy_document" "this" {
  statement {
    sid       = "GeneratedStatement"
    effect    = var.effect
    actions   = var.actions
    resources = var.resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
