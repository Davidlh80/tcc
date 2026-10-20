resource "aws_iam_role" "template_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = var.trusted_service
        }
      },
    ]
  })

  tags = {
    name        = var.role_name
    environment = var.environment
    owner       = var.owner
  }
}

resource "aws_iam_policy" "template_policy" {
  name        = var.policy_name
  path        = "/"
  description = "Policy for ${var.role_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.allowed_actions
        Effect   = "Allow"
        Resource = var.allowed_resources
      },
    ]
  })

  tags = {
    name        = var.policy_name
    environment = var.environment
    owner       = var.owner
  }
}

resource "aws_iam_role_policy_attachment" "template_attach" {
  role       = aws_iam_role.template_role.name
  policy_arn = aws_iam_policy.template_policy.arn
}
