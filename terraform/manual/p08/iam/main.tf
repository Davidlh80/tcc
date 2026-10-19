resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Policy IAM para o ambiente ${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect   = "Allow"
        Action   = var.allowed_actions
        Resource = var.allowed_resources
      }
    ]
  })

  tags = {
    Name        = var.policy_name
    Environment = var.environment
  }
}

resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = var.trusted_principal
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = var.role_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
