terraform {
  required_version = ">= 1.5.0"
}

locals {
  base_name   = "${var.environment}-${var.system}-iam-${var.policy_name}"
  policy_name = "${local.base_name}-policy"
  role_name   = "${local.base_name}-role"

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

  has_full_wildcard_statement = (
    contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*")
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

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*"
      error_message = "trusted_principal_arn nao pode ser \"*\": a trust policy deve restringir um principal especifico."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Policy de minimo privilegio para ${var.system} (${var.environment}), gerenciada via Terraform."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = !local.has_full_wildcard_statement
      error_message = "Statement com Action = \"*\" combinado com Resource = \"*\" nao e permitida. Restrinja allowed_actions e/ou allowed_resources."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
