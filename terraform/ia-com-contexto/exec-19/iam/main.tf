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

  tags = merge(var.additional_tags, local.required_tags)

  description = coalesce(var.description, "IAM policy for ${var.system} managed by Terraform")
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowRequestedActions"
    effect  = "Allow"
    actions = var.allowed_actions

    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.resource_name
  description = local.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Security control violation: It is prohibited to create a statement combining Action \"*\" with Resource \"*\"."
    }
  }
}
