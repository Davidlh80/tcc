provider "aws" {
  region = var.region
}

locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  common_tags = merge(
    var.additional_tags,
    {
      Project     = "tcc-iac-ia"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "devops"
      CostCenter  = "academic-research"
    }
  )
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowConfiguredActionsOnConfiguredResources"
    effect  = "Allow"
    actions = var.allowed_actions

    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.common_tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Combinar Action \"*\" com Resource \"*\" na mesma statement é proibido pelo contexto organizacional."
    }
  }
}
