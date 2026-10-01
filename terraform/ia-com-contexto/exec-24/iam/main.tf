provider "aws" {
  region = var.region
}

locals {
  name_prefix = "${var.environment}-${var.system}"
  policy_name = "${local.name_prefix}-iam-policy-${var.policy_name}"
  role_name   = "${local.name_prefix}-iam-role-${var.policy_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)
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

data "aws_iam_policy_document" "policy" {
  statement {
    sid       = "LeastPrivilegeAllow"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Policy de menor privilegio (finalidade: ${var.policy_name}), gerenciada via Terraform."
  policy      = data.aws_iam_policy_document.policy.json

  tags = local.tags
}

resource "aws_iam_role" "this" {
  name               = local.role_name
  description        = "Role assumida apenas pelo principal confiavel configurado (finalidade: ${var.policy_name})."
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
