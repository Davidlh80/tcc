terraform {
  required_version = ">= 1.5"
}

locals {
  role_name   = "${var.name}-role"
  policy_name = "${var.name}-policy"

  tags = merge(
    {
      Name      = local.role_name
      ManagedBy = "terraform"
    },
    var.tags
  )
}

check "assume_role_principal_required" {
  assert {
    condition     = length(var.trusted_service_principals) > 0 || length(var.trusted_aws_principals) > 0
    error_message = "Defina ao menos um principal de confianca em trusted_service_principals ou trusted_aws_principals."
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AssumeRoleTrustPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = length(var.trusted_service_principals) > 0 ? [var.trusted_service_principals] : []
      content {
        type        = "Service"
        identifiers = principals.value
      }
    }

    dynamic "principals" {
      for_each = length(var.trusted_aws_principals) > 0 ? [var.trusted_aws_principals] : []
      content {
        type        = "AWS"
        identifiers = principals.value
      }
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
      for_each = var.require_mfa_for_aws_principals && length(var.trusted_aws_principals) > 0 ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  path                 = var.iam_path
  description          = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn
  force_detach_policies = true

  tags = local.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "PolicyStatement"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources

    dynamic "condition" {
      for_each = var.require_secure_transport ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["true"]
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  path        = var.iam_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
