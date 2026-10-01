provider "aws" {
  region = var.region
}

locals {
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

  policy_name_full = "${var.environment}-${var.system}-iam-policy-${var.policy_name}"
  role_name_full   = "${var.environment}-${var.system}-iam-role-${var.policy_name}"

  has_wildcard_action   = contains(var.allowed_actions, "*")
  has_wildcard_resource = contains(var.allowed_resources, "*")
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

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_name_full
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name_full
  description = "Policy gerenciada via Terraform para a finalidade: ${var.policy_name}"
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(local.has_wildcard_action && local.has_wildcard_resource)
      error_message = "A statement Allow nao pode combinar Action \"*\" com Resource \"*\" na mesma policy."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
