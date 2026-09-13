terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowLeastPrivilegeAccess"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
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
