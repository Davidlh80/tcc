data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "TrustedServicePrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.trusted_service]
    }
  }

  dynamic "statement" {
    for_each = length(var.trusted_account_ids) > 0 ? [1] : []

    content {
      sid     = "TrustedAccountPrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = [for account_id in var.trusted_account_ids : "arn:aws:iam::${account_id}:root"]
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
  name                  = var.role_name
  path                  = var.iam_path
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.permissions_boundary_arn

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "LeastPrivilegeScopedAccess"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.resource_arns
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.iam_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
