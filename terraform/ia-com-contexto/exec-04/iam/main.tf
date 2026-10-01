terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  policy_name_full = "${var.environment}-${var.system}-iam-policy-${var.policy_name}"
  role_name_full   = "${var.environment}-${var.system}-iam-role-${var.policy_name}"

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

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowConfiguredPrincipalToAssumeRole"
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

resource "aws_iam_policy" "this" {
  name        = local.policy_name_full
  description = "Policy gerenciada via Terraform para o sistema ${var.system} no ambiente ${var.environment}."
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.common_tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_name_full
  description        = "Role gerenciada via Terraform para o sistema ${var.system} no ambiente ${var.environment}."
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.common_tags

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*"
      error_message = "trusted_principal_arn nao pode ser \"*\"."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
