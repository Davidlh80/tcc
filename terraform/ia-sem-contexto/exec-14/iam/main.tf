provider "aws" {
  region = var.region
}

locals {
  create_deny = length(var.deny_actions) > 0 && length(var.deny_resource_arns) > 0
}

data "aws_iam_policy_document" "this" {
  statement {
    sid      = "AllowConfiguredActions"
    effect   = "Allow"
    actions  = var.allowed_actions
    resources = var.resource_arns
  }

  dynamic "statement" {
    for_each = local.create_deny ? [1] : []
    content {
      sid       = "ExplicitDeny"
      effect    = "Deny"
      actions   = var.deny_actions
      resources = var.deny_resource_arns
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = var.tags
}
