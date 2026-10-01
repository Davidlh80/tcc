terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  name_prefix = "${var.environment}-${var.system}"
  policy_name = "${local.name_prefix}-iam-${var.policy_name}"
  role_name   = "${local.name_prefix}-iam-role-${var.policy_name}"

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.required_tags, var.additional_tags)
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name
  description = "Policy de menor privilegio gerenciada via Terraform para ${local.name_prefix}."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "LeastPrivilegeAllow"
        Effect   = "Allow"
        Action   = var.allowed_actions
        Resource = var.allowed_resources
      }
    ]
  })

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role" "this" {
  name = local.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "TrustedPrincipalAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_principal_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
