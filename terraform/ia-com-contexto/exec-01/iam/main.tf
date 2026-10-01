locals {
  name_prefix = "${var.environment}-${var.system}"

  policy_full_name = "${local.name_prefix}-iam-${var.policy_name}"
  role_full_name   = "${local.name_prefix}-iam-${var.role_name}"

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

provider "aws" {
  region = var.region
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = "Policy de menor privilegio para ${var.policy_name}, gerenciada via Terraform."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowConfiguredActions"
        Effect   = "Allow"
        Action   = var.allowed_actions
        Resource = var.allowed_resources
      }
    ]
  })

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement da policy."
    }
  }
}

resource "aws_iam_role" "this" {
  name = local.role_full_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSpecificPrincipalAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_principal_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*"
      error_message = "A trust policy da role nao pode utilizar Principal = \"*\"."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
