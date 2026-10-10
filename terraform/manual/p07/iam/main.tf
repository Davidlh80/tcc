locals {
  tags = merge(var.additional_tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.trusted_service]
    }
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "main" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

resource "aws_iam_policy" "main" {
  name        = var.policy_name
  description = "Policy de menor privilegio para a role ${var.role_name}"
  policy      = data.aws_iam_policy_document.policy.json
  tags        = local.tags
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}
