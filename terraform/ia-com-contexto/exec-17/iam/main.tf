provider "aws" {
  region = var.region
}

locals {
  name_prefix       = "${var.environment}-${var.system}"
  policy_name_full  = "${local.name_prefix}-iam-policy-${var.policy_name}"
  role_name_full    = "${local.name_prefix}-iam-role-${var.policy_name}"

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

  has_full_wildcard_statement = contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*")
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActions"
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
  name        = local.policy_name_full
  description = "Policy de menor privilegio gerenciada via Terraform para ${local.policy_name_full}."
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !local.has_full_wildcard_statement
      error_message = "Combinacao proibida: Action \"*\" junto com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_name_full
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
