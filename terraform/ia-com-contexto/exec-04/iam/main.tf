terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  tags = merge(
    {
      Project     = "tcc-iac-ia"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "devops"
      CostCenter  = "academic-research"
    },
    var.additional_tags
  )

  has_full_wildcard_action   = contains(var.allowed_actions, "*")
  has_full_wildcard_resource = contains(var.allowed_resources, "*")
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.name
  description = var.description
  path        = "/"
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(local.has_full_wildcard_action && local.has_full_wildcard_resource)
      error_message = "A statement não pode combinar Action \"*\" com Resource \"*\". Restrinja allowed_actions e/ou allowed_resources."
    }
  }
}
