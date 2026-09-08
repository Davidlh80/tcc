provider "aws" {
  region = var.aws_region
}

locals {
  merged_tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"

  statement {
    sid       = "AllowListedActionsOnListedResources"
    effect    = "Allow"
    actions   = var.actions
    resources = var.resources
  }

  dynamic "statement" {
    for_each = length(var.deny_actions) > 0 ? [1] : []
    content {
      sid       = "ExplicitDeny"
      effect    = "Deny"
      actions   = var.deny_actions
      resources = var.deny_resources
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.merged_tags
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each   = toset(var.attach_to_users)
  user       = each.value
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.attach_to_roles)
  role       = each.value
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each   = toset(var.attach_to_groups)
  group      = each.value
  policy_arn = aws_iam_policy.this.arn
}
