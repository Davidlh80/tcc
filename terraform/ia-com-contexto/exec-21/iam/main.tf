provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(var.additional_tags, local.mandatory_tags)

  policy_description_effective = var.policy_description != "" ? var.policy_description : "IAM policy for ${local.resource_name}"
}

resource "aws_iam_policy" "this" {
  name        = local.resource_name
  path        = var.policy_path
  description = local.policy_description_effective

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowConfiguredActions"
        Effect   = "Allow"
        Action   = var.allowed_actions
        Resource = var.allowed_resources
      }
    ]
  })

  tags = local.tags
}
