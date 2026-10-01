terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  base_name        = "${var.environment}-${var.system}-iam-${var.policy_name}"
  iam_policy_name  = "${local.base_name}-policy"
  iam_role_name    = "${local.base_name}-role"

  tags = merge(
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

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowTrustedPrincipalAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.iam_policy_name
  description = "Policy de minimo privilegio para ${var.system} (${var.policy_name}) no ambiente ${var.environment}"
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Statement nao pode combinar Action = \"*\" com Resource = \"*\". Restrinja var.allowed_actions e/ou var.allowed_resources."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.iam_role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600
  tags                 = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
