terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  name_prefix      = "${var.environment}-${var.system}"
  policy_full_name = "${local.name_prefix}-iam-policy-${var.policy_name}"
  role_full_name   = "${local.name_prefix}-iam-role-${var.policy_name}"

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
  name                 = local.role_full_name
  description          = coalesce(var.role_description, "Role IAM gerenciada via Terraform para ${var.policy_name}")
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration

  lifecycle {
    precondition {
      condition     = !contains(var.trusted_principal_identifiers, "*")
      error_message = "O principal confiavel nao pode ser \"*\". Informe identificadores especificos em var.trusted_principal_identifiers."
    }
  }

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = coalesce(var.policy_description, "Policy IAM gerenciada via Terraform para ${var.policy_name}")
  policy      = data.aws_iam_policy_document.this.json

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Uma statement Effect=Allow nao pode combinar Action = \"*\" com Resource = \"*\"."
    }
  }

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
