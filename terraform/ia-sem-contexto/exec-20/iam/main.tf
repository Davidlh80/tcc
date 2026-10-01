data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowTrustedPrincipalAssumeRole"
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
      for_each = var.require_mfa ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  path                  = var.role_path
  description           = var.role_description
  assume_role_policy     = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = true

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowScopedActionsOnDefinedResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.resource_arns
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
