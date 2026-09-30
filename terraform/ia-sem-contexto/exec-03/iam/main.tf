data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AssumeRoleTrust"
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
      for_each = length(var.trusted_aws_principals) > 0 ? [1] : []
      content {
        type        = "AWS"
        identifiers = var.trusted_aws_principals
      }
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

data "aws_iam_policy_document" "role_policy" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary_arn != "" ? var.permissions_boundary_arn : null
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

provider "aws" {
  region = var.aws_region
}
