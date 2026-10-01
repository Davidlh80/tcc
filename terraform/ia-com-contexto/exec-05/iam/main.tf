provider "aws" {
  region = var.region
}

locals {
  name_prefix = "${var.environment}-${var.system}"
  policy_name = "${local.name_prefix}-iam-policy-${var.policy_name}"
  role_name   = "${local.name_prefix}-iam-role-${var.policy_name}"

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

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "LeastPrivilegeAllow"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Policy de privilegio minimo para a finalidade '${var.policy_name}' no ambiente ${var.environment}."
  policy      = data.aws_iam_policy_document.this.json

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nenhuma statement da policy pode combinar Action = \"*\" com Resource = \"*\"."
    }
  }

  tags = local.tags
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  description          = "IAM Role dedicada a finalidade '${var.policy_name}' no ambiente ${var.environment}."
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*"
      error_message = "trusted_principal_arn nao pode ser \"*\"; informe um principal especifico."
    }
  }

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
