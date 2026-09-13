locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  default_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.default_tags, var.additional_tags)
}

provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowRestrictedActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A statement nao pode combinar Action \"*\" com Resource \"*\". Restrinja pelo menos uma das listas a valores especificos."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags
}
