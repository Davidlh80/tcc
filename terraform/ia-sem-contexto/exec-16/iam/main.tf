data "aws_iam_policy_document" "this" {
  statement {
    sid       = "CustomPolicyStatement"
    effect    = var.policy_effect
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
