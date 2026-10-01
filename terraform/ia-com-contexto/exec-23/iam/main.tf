terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  name_prefix      = "${var.environment}-${var.system}-iam"
  policy_name_full = "${local.name_prefix}-${var.policy_name}"
  role_name_full    = "${local.policy_name_full}-role"

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

  wildcard_violation = contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*")
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowConfiguredPrincipalAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name_full
  description = "Policy ${local.policy_name_full} gerenciada via Terraform, com acoes e recursos restritos por variavel."
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.common_tags

  lifecycle {
    precondition {
      condition     = !local.wildcard_violation
      error_message = "A combinacao de Action \"*\" com Resource \"*\" na mesma statement nao e permitida."
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = local.role_name_full
  assume_role_policy    = data.aws_iam_policy_document.trust.json
  max_session_duration  = var.max_session_duration
  tags                  = local.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
