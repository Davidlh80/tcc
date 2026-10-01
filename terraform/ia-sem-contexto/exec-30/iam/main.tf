terraform {
  required_version = ">= 1.9.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "TrustedPrincipalAssumeRole"
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
  description           = var.role_description
  path                  = var.path
  max_session_duration  = var.max_session_duration
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = var.force_detach_policies

  tags = merge(
    {
      Name      = var.role_name
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.path
  policy      = data.aws_iam_policy_document.role_policy.json

  tags = merge(
    {
      Name      = var.policy_name
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = toset(var.additional_managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
