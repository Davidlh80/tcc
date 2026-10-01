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
      ManagedBy = "Terraform"
    }
  )
}

# Trust policy (who is allowed to assume the role).
# By default only the AWS service principals in var.trusted_service_principals
# can assume it. Cross-account assumption via var.trusted_account_arns is
# disabled by default (empty list) and, when enabled, can be further
# restricted with an external ID condition.
data "aws_iam_policy_document" "assume_role" {
  dynamic "statement" {
    for_each = length(var.trusted_service_principals) > 0 ? [1] : []
    content {
      sid     = "AllowServicePrincipalsAssumeRole"
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
      sid     = "AllowCrossAccountAssumeRole"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = var.trusted_account_arns
      }

      dynamic "condition" {
        for_each = var.external_id != null ? [var.external_id] : []
        content {
          test     = "StringEquals"
          variable = "sts:ExternalId"
          values   = [condition.value]
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  path                 = var.path
  description          = var.role_description
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn

  tags = local.common_tags
}

# Least-privilege permissions policy: read-only access to a single,
# explicitly named S3 bucket. No wildcard resources or actions.
data "aws_iam_policy_document" "permissions" {
  statement {
    sid    = "ListSpecificBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}"
    ]
  }

  statement {
    sid    = "ReadObjectsInSpecificBucket"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.common_tags
}

# The policy is always attached to the role created above — it is never
# left unattached without a principal.
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
