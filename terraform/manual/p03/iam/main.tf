provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AllowTrustedPrincipalAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"

      identifiers = [
        var.trusted_principal_arn
      ]
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
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.common_tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "IAM policy managed by Terraform for ${var.environment}."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
