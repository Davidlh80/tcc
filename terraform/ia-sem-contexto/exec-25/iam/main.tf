terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  common_tags = merge(
    {
      "ManagedBy" = "terraform"
    },
    var.tags
  )
}

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
      for_each = length(var.trusted_principal_arns) > 0 ? [1] : []
      content {
        type        = "AWS"
        identifiers = var.trusted_principal_arns
      }
    }

    dynamic "condition" {
      for_each = var.external_id != null && var.external_id != "" ? [var.external_id] : []
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [condition.value]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = "${var.name_prefix}-role"
  path                 = var.path
  description          = "IAM role provisionada via Terraform, sem principal wildcard e com policy de permissoes anexada explicitamente."
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn

  tags = merge(local.common_tags, { Name = "${var.name_prefix}-role" })

  lifecycle {
    precondition {
      condition     = length(var.trusted_service_principals) > 0 || length(var.trusted_principal_arns) > 0
      error_message = "Defina pelo menos um principal em trusted_service_principals ou trusted_principal_arns. Roles sem principal de confianca nao sao permitidas."
    }
  }
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    sid       = "LeastPrivilegeAccess"
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.name_prefix}-policy"
  path        = var.path
  description = "Policy de permissoes minimas anexada exclusivamente a role ${var.name_prefix}-role."
  policy      = data.aws_iam_policy_document.role_policy.json

  tags = merge(local.common_tags, { Name = "${var.name_prefix}-policy" })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
