terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowAssumeRoleByTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

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
  assume_role_policy     = data.aws_iam_policy_document.assume_role.json
  max_session_duration   = var.max_session_duration
  permissions_boundary   = var.permissions_boundary_arn
  force_detach_policies  = var.force_detach_policies

  tags = var.tags
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.resource_arns
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = "Managed policy attached to role ${var.role_name}; scope limited to the actions and resources defined via variables."
  policy      = data.aws_iam_policy_document.role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
