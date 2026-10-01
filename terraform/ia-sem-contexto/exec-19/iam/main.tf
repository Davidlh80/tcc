data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  trust_principal = merge(
    length(var.trusted_service_principals) > 0 ? { Service = var.trusted_service_principals } : {},
    length(var.trusted_aws_principals) > 0 ? { AWS = var.trusted_aws_principals } : {}
  )

  log_group_arn = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}:*"
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = var.role_description
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn
  force_detach_policies = var.force_detach_policies

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "TrustedPrincipalAssumeRole"
        Effect    = "Allow"
        Principal = local.trust_principal
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowScopedLogging"
        Effect   = "Allow"
        Action   = var.policy_actions
        Resource = [local.log_group_arn]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
