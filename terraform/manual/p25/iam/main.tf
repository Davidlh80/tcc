provider "aws" {
  region = var.aws_region
}

# Locals para centralizar as tags padrão e evitar repetição
locals {
  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.additional_tags
  )
}

# 1. Trust Policy (Assume Role) restrita a um principal específico (sem coringa amplo)
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [var.trusted_service]
    }
  }
}

# 2. Criação da IAM Role associada à Trust Policy
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.common_tags
}

# 3. Policy IAM com base no princípio do menor privilégio (ações e recursos restritos)
resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Policy de menor privilégio gerada por Terraform para o ambiente ${var.environment}"

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

  tags = local.common_tags
}

# 4. Anexação obrigatória da Policy à Role (evita policy solta sem principal associado)
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
