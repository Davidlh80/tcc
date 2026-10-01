data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowAssumeRoleByTrustedPrincipal"
    effect  = "Allow"
    actions = var.assume_role_actions

    principals {
      type        = var.trusted_principal_type
      identifiers = var.trusted_principal_identifiers
    }

    dynamic "condition" {
      for_each = var.external_id != "" ? [var.external_id] : []
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [condition.value]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  path                  = var.path
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.permissions_boundary_arn != "" ? var.permissions_boundary_arn : null

  tags = var.tags
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.permissions.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
