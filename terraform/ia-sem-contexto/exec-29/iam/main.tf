data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = length(var.trusted_service_principals) > 0 ? [1] : []
      content {
        type        = "Service"
        identifiers = var.trusted_service_principals
      }
    }

    dynamic "principals" {
      for_each = length(var.trusted_principal_arns) > 0 ? [1] : []
      content {
        type        = "AWS"
        identifiers = var.trusted_principal_arns
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
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  path                 = var.role_path
  description          = var.role_description
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn

  tags = var.tags

  lifecycle {
    precondition {
      condition     = length(var.trusted_service_principals) > 0 || length(var.trusted_principal_arns) > 0
      error_message = "Informe ao menos um principal confiavel em trusted_service_principals ou trusted_principal_arns; a role nao pode ficar sem principal de confianca."
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowScopedActions"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.role_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
