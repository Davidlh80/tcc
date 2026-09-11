provider "aws" {
  region = var.region
}

locals {
  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  # Tags obrigatórias prevalecem sobre adicionais em caso de conflito
  tags = merge(var.additional_tags, local.mandatory_tags)

  actions   = distinct(var.allowed_actions)
  resources = distinct(var.allowed_resources)

  # Proibição explícita: não permitir Action:"*" com Resource:"*"
  wildcard_both = contains(local.actions, "*") && contains(local.resources, "*")
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  path        = "/"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowConfiguredActions"
        Effect   = "Allow"
        Action   = local.actions
        Resource = local.resources
      }
    ]
  })

  tags = local.tags

  lifecycle {
    precondition {
      condition     = length(local.actions) > 0 && length(local.resources) > 0
      error_message = "As variáveis allowed_actions e allowed_resources devem conter pelo menos um item."
    }
    precondition {
      condition     = !local.wildcard_both
      error_message = "Proibido combinar Action: \"*\" com Resource: \"*\" na mesma policy statement."
    }
  }
}
