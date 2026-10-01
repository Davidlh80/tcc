terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  name_prefix      = "${var.environment}-${var.system}"
  policy_full_name = "${local.name_prefix}-iam-policy-${var.policy_name}"
  role_full_name   = "${local.name_prefix}-iam-role-${var.policy_name}"

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

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_full_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*" && !strcontains(var.trusted_principal_arn, "*")
      error_message = "trusted_principal_arn nao pode ser um wildcard (\"*\")."
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = local.policy_full_name
  policy = data.aws_iam_policy_document.this.json
  tags   = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
