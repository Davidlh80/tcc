terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  name_prefix = "${var.environment}-${var.system}"

  policy_full_name = "${local.name_prefix}-iam-policy-${var.policy_name}"
  role_full_name   = "${local.name_prefix}-iam-role-${var.policy_name}"

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

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowConfiguredPrincipalToAssumeRole"
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
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A combinacao de Action \"*\" com Resource \"*\" na mesma statement nao e permitida pela politica organizacional."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = "Policy gerenciada por Terraform com permissoes restritas as acoes e recursos configurados por variavel."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.common_tags
}

resource "aws_iam_role" "this" {
  name                 = local.role_full_name
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
