terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowAssumeRole"
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
  }
}

data "aws_iam_policy_document" "permissions" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  path                  = var.role_path
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.permissions_boundary_arn

  tags = var.tags

  lifecycle {
    precondition {
      condition     = length(var.trusted_service_principals) > 0 || length(var.trusted_aws_principals) > 0
      error_message = "Informe ao menos um principal de confianca em trusted_service_principals ou trusted_aws_principals."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.permissions.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
