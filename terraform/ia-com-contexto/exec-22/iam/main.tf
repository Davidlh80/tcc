provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  base_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  # Base tags take precedence over additional_tags to enforce mandatory values
  tags = merge(var.additional_tags, local.base_tags)

  actions_is_all   = contains(var.allowed_actions, "*")
  resources_is_all = contains(var.allowed_resource_arns, "*")
}

resource "aws_iam_policy" "this" {
  name        = local.resource_name
  description = var.policy_description

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowConfiguredActionsOnConfiguredResources"
        Effect   = "Allow"
        Action   = tolist(toset(var.allowed_actions))
        Resource = tolist(toset(var.allowed_resource_arns))
      }
    ]
  })

  tags = local.tags

  lifecycle {
    precondition {
      condition     = !(local.actions_is_all && local.resources_is_all)
      error_message = "Proibido combinar Action=\"*\" com Resource=\"*\" na mesma policy statement."
    }
  }
}
