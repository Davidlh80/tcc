terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  name_prefix      = "${var.environment}-${var.system}"
  policy_full_name = "${local.name_prefix}-iam-${var.policy_name}"
  role_full_name   = "${local.name_prefix}-iam-${var.policy_name}-role"

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
    sid     = "AssumeRoleTrustedPrincipal"
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
    sid       = "LeastPrivilegeAllow"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_full_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration

  tags = local.tags

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*" && var.trusted_principal_arn != "arn:aws:iam::*:root"
      error_message = "trusted_principal_arn nao pode ser um coringa (\"*\" ou conta root coringa); informe um ARN especifico."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = "Policy de minimo privilegio para ${local.name_prefix} (${var.policy_name})."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.tags

  lifecycle {
    precondition {
      condition = !(
        contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*")
      )
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
