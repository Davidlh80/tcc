terraform {
  required_version = ">= 1.5.0"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = var.trusted_principal_type
      identifiers = var.trusted_principal_identifiers
    }

    dynamic "condition" {
      for_each = var.external_id != null ? [var.external_id] : []
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [condition.value]
      }
    }

    dynamic "condition" {
      for_each = var.require_mfa ? [true] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
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
  force_detach_policies = true

  tags = merge(
    {
      "ManagedBy" = "terraform"
    },
    var.tags
  )
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resource_arns
  }

  dynamic "statement" {
    for_each = length(var.denied_actions) > 0 ? [1] : []
    content {
      sid       = "DenyConfiguredActions"
      effect    = "Deny"
      actions   = var.denied_actions
      resources = ["*"]
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.role_policy.json

  tags = merge(
    {
      "ManagedBy" = "terraform"
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
