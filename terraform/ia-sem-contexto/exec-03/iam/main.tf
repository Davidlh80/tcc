provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowAssumeRoleFromTrustedPrincipals"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }

    dynamic "condition" {
      for_each = var.external_id == null ? [] : [var.external_id]

      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [condition.value]
      }
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "ScopedLeastPrivilegePermissions"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = "Role assumable only by principals explicitly listed in trusted_principal_arns"
  assume_role_policy    = data.aws_iam_policy_document.trust.json
  max_session_duration  = var.max_session_duration

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Least-privilege policy scoped to specific actions and resources, attached to ${var.role_name}"
  policy      = data.aws_iam_policy_document.permissions.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
