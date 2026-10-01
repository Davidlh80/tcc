terraform {
  required_version = ">= 1.9.0"
}

provider "aws" {
  region = var.region
}

locals {
  name_prefix = "${var.environment}-${var.system}"
  policy_name = "${local.name_prefix}-iam-${var.policy_name}"
  role_name   = "${local.name_prefix}-iam-${var.policy_name}-role"

  common_tags = merge(
    {
      Project     = "tcc-iac-ia"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "devops"
      CostCenter  = "academic-research"
    },
    var.additional_tags
  )
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowTrustedPrincipalAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration

  tags = local.common_tags
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Policy de menor privilegio (${var.policy_name}) gerenciada via Terraform."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
