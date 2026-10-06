locals {
  tags = merge(
    var.additional_tags,
    {
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Policy de menor privilégio do ambiente ${var.environment}."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = merge(local.tags, { Name = var.policy_name })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = var.trusted_principal_type
      identifiers = [var.trusted_principal_arn]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  description        = "Role do ambiente ${var.environment} com acesso restrito à policy ${var.policy_name}."
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(local.tags, { Name = var.role_name })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
