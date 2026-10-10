locals {
  tags = merge(var.additional_tags, {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  })
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

data "aws_iam_policy_document" "permissions" {
  statement {
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.environment}-${var.system}-iam-${var.policy_name}"
  policy = data.aws_iam_policy_document.permissions.json
  tags   = local.tags
}

resource "aws_iam_role" "this" {
  name               = "${var.environment}-${var.system}-iam-${var.role_name}"
  assume_role_policy = data.aws_iam_policy_document.trust.json
  tags               = local.tags
  lifecycle {
    precondition {
      condition     = length("${var.environment}-${var.system}-iam-${var.role_name}") <= 64
      error_message = "O nome final da role deve ter no maximo 64 caracteres."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
