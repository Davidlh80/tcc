provider "aws" {
  region = var.region
}

locals {
  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)

  policy_full_name = "${var.environment}-${var.system}-iam-policy-${var.policy_name}"
  role_full_name   = "${var.environment}-${var.system}-iam-role-${var.role_name}"
}

check "no_full_wildcard_statement" {
  assert {
    condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
    error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement."
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowConfiguredTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = var.trusted_principal_type
      identifiers = var.trusted_principal_identifiers
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
  description        = "IAM Role gerenciada via Terraform, com trust policy restrita ao principal configurado."
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
