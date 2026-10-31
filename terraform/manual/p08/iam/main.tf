data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "ConfiguredPermissions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.permissions.json

  tags = merge(var.tags, {
    Name        = var.policy_name
    Environment = var.environment
  })
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "ConfiguredTrust"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = var.trusted_principal_type
      identifiers = var.trusted_principal_identifiers
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
  description        = var.role_description

  tags = merge(var.tags, {
    Name        = var.role_name
    Environment = var.environment
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
