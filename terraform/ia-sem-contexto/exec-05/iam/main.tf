provider "aws" {
  region = var.aws_region
}

locals {
  effective_tags = merge(
    {
      ManagedBy = "Terraform"
      Name      = var.policy_name
    },
    var.tags
  )

  effective_description = coalesce(
    var.policy_description,
    format(
      "Managed IAM policy created by Terraform. Allows configured actions with optional region/IP restrictions%s.",
      var.enforce_mfa ? " and denies all actions when MFA is not present" : ""
    )
  )
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowConfiguredActions"
    effect  = "Allow"
    actions = var.allowed_actions

    resources = var.policy_resources

    dynamic "condition" {
      for_each = length(var.allowed_regions) > 0 ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:RequestedRegion"
        values   = var.allowed_regions
      }
    }

    dynamic "condition" {
      for_each = length(var.allowed_source_ips) > 0 ? [1] : []
      content {
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = var.allowed_source_ips
      }
    }
  }

  dynamic "statement" {
    for_each = var.enforce_mfa ? [1] : []
    content {
      sid    = "DenyAllIfNotMFA"
      effect = "Deny"

      actions   = ["*"]
      resources = ["*"]

      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["false"]
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = local.effective_description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.effective_tags
}
