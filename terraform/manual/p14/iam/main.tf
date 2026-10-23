locals {
  tags = merge(
    {
      Project     = "tcc"
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.additional_tags
  )
}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Policy de menor privilégio com as ações e recursos definidos por variável"
  policy      = data.aws_iam_policy_document.permissions.json
  tags        = local.tags
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
