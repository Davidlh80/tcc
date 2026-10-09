locals {
  tags = merge(var.additional_tags, {
    Environment = var.environment
    Project     = "tcc-iac-ia"
    ManagedBy   = "terraform"
  })
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowedActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = "Role ${var.role_name} (${var.environment})"
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600
  tags                 = local.tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Permissoes da role ${var.role_name} (${var.environment})"
  policy      = data.aws_iam_policy_document.permissions.json
  tags        = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
