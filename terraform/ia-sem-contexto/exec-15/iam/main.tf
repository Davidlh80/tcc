data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowConfiguredPrincipalToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = var.assume_role_principal_type
      identifiers = var.assume_role_principal_identifiers
    }

    dynamic "condition" {
      for_each = var.assume_role_external_id != null ? [var.assume_role_external_id] : []
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
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.resource_arns
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  path                  = var.path
  description           = var.description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.permissions_boundary_arn

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = "Policy com permissoes minimas necessarias, anexada a role ${var.role_name}."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
