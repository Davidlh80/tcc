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

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AssumeRoleTrust"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid       = "LeastPrivilegeAccess"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  description          = "Role gerenciada via Terraform - ${var.policy_description}"
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = var.max_session_duration

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !contains(var.trusted_principal_arns, "*")
      error_message = "trusted_principal_arns nao pode conter '*'; a trust policy deve restringir o principal a ARNs especificos."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.permissions.json

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action '*' com Resource '*' na mesma statement."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
