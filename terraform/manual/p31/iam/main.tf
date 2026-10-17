locals {
  role_tags = merge(var.additional_tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "tcc-iac-p31"
    Name        = var.role_name
  })

  policy_tags = merge(var.additional_tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "tcc-iac-p31"
    Name        = var.policy_name
  })
}

resource "aws_iam_role" "workload" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = var.trusted_service
      }
    }]
  })

  tags = local.role_tags
}

resource "aws_iam_policy" "workload" {
  name        = var.policy_name
  description = "Least-privilege permissions for ${var.role_name}."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = var.allowed_actions
      Resource = var.allowed_resources
    }]
  })

  tags = local.policy_tags
}

resource "aws_iam_role_policy_attachment" "workload" {
  role       = aws_iam_role.workload.name
  policy_arn = aws_iam_policy.workload.arn
}
