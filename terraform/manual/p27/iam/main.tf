data "aws_partition" "current" {}

locals {
  policy_name = "${var.environment}-${var.policy_name}"
  role_name   = "${var.environment}-${var.role_name}"

  common_tags = merge(var.additional_tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "IAM"
  })
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowConfiguredPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = var.trusted_principal_type
      identifiers = var.trusted_principal_identifiers
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Permissoes para o ambiente ${var.environment}"
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = length(local.policy_name) <= 128
      error_message = "O nome final da policy deve ter no maximo 128 caracteres."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  description          = "Role IAM para ${var.environment}"
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = var.max_session_duration

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = length(local.role_name) <= 64
      error_message = "O nome final da role deve ter no maximo 64 caracteres."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
