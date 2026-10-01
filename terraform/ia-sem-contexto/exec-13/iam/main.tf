terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    var.tags,
    {
      ManagedBy = "terraform"
    }
  )
}

data "aws_iam_policy_document" "assume_role" {
  dynamic "statement" {
    for_each = length(var.trusted_service_principals) > 0 ? [1] : []

    content {
      sid     = "TrustedServicePrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = var.trusted_service_principals
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.trusted_account_arns) > 0 ? [1] : []

    content {
      sid     = "TrustedAccountPrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = var.trusted_account_arns
      }

      dynamic "condition" {
        for_each = var.external_id != "" ? [1] : []

        content {
          test     = "StringEquals"
          variable = "sts:ExternalId"
          values   = [var.external_id]
        }
      }
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowedActions"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  path                 = var.path
  description          = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn != "" ? var.permissions_boundary_arn : null
  force_detach_policies = var.force_detach_policies

  tags = local.common_tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
