terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  policy_name = "${var.environment}-${var.system}-iam-${var.policy_name}"
  role_name   = "${var.environment}-${var.system}-iam-role-${var.policy_name}"

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

  has_wildcard_action   = contains(var.allowed_actions, "*")
  has_wildcard_resource = contains(var.allowed_resources, "*")
}

data "aws_iam_policy_document" "assume_role" {
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

data "aws_iam_policy_document" "this" {
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
  max_session_duration = var.max_session_duration
  tags                 = local.tags
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Policy de menor privilegio para ${var.system} (${var.environment}) - finalidade: ${var.policy_name}"
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(local.has_wildcard_action && local.has_wildcard_resource)
      error_message = "A statement da policy nao pode combinar Action = \"*\" com Resource = \"*\". Restrinja allowed_actions ou allowed_resources."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
