provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "default" {
  statement {
    sid     = var.policy_sid
    effect  = "Allow"
    actions = var.default_actions
    resources = var.default_resources
  }
}

locals {
  effective_policy_json = length(trimspace(var.policy_document_json)) > 0 ? var.policy_document_json : data.aws_iam_policy_document.default.json
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = local.effective_policy_json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = var.attach_to_roles
  role       = each.value
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each   = var.attach_to_users
  user       = each.value
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each   = var.attach_to_groups
  group      = each.value
  policy_arn = aws_iam_policy.this.arn
}
