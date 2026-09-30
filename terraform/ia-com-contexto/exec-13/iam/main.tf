terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  full_policy_name = "${var.environment}-${var.system}-iam-${var.policy_name}"
  full_role_name   = "${var.environment}-${var.system}-iam-${var.role_name}"

  deny_full_wildcard = contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*")

  trust_principal_is_iam_arn = can(regex("^arn:aws:iam::", var.trusted_principal_arn))
  trust_principal_type       = local.trust_principal_is_iam_arn ? "AWS" : "Service"

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
    sid     = "AllowAssumeRoleFromTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = local.trust_principal_type
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
  name                 = local.full_role_name
  description          = "Role IAM gerenciada via Terraform - finalidade: ${var.role_name}"
  assume_role_policy    = data.aws_iam_policy_document.trust.json
  max_session_duration  = var.max_session_duration

  tags = local.common_tags
}

resource "aws_iam_policy" "this" {
  name        = local.full_policy_name
  description = "Policy IAM gerenciada via Terraform - finalidade: ${var.policy_name}"
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = !local.deny_full_wildcard
      error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement da policy."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
