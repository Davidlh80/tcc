provider "aws" {
  region = var.region
}

locals {
  resource_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  # Required tags take precedence over additional_tags
  tags = merge(var.additional_tags, local.required_tags)

  description = coalesce(var.policy_description, "Managed policy for ${local.resource_name}")
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowExplicitActionsOnExplicitResources"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.resource_name
  path        = var.path
  description = local.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Forbidden: A single statement cannot combine Action \"*\" with Resource \"*\"."
    }
  }
}
