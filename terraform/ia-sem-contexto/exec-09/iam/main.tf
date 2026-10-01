terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

locals {
  assume_role_statement = merge(
    {
      Sid       = "AllowTrustedPrincipalAssumeRole"
      Effect    = "Allow"
      Principal = { Service = var.trusted_principal_service }
      Action    = "sts:AssumeRole"
    },
    var.external_id != null ? {
      Condition = {
        StringEquals = {
          "sts:ExternalId" = var.external_id
        }
      }
    } : {}
  )

  common_tags = merge(
    {
      ManagedBy = "Terraform"
      Component = "iam-role-policy"
    },
    var.tags
  )
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = var.role_description
  max_session_duration = var.max_session_duration

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [local.assume_role_statement]
  })

  tags = local.common_tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowScopedActions"
        Effect   = "Allow"
        Action   = var.policy_actions
        Resource = var.policy_resources
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
