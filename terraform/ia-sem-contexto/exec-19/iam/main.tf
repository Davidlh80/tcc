locals {
  assume_role_statement = merge(
    {
      Sid       = "AllowConfiguredPrincipalToAssumeRole"
      Effect    = "Allow"
      Principal = { AWS = var.trusted_principal_arn }
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
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = var.role_description
  max_session_duration = var.max_session_duration

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [local.assume_role_statement]
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
        Sid      = "AllowScopedActionsOnScopedResources"
        Effect   = "Allow"
        Action   = var.policy_actions
        Resource = var.policy_resources
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
