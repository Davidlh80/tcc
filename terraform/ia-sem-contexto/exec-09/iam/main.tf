terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowSpecifiedActions"
    effect    = var.effect
    actions   = var.allowed_actions
    resources = var.allowed_resources

    dynamic "condition" {
      for_each = var.enforce_secure_transport ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["true"]
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}
