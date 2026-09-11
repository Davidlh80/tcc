provider "aws" {
  region = var.region
}

locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowScopedActions"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  path        = var.policy_path
  description = coalesce(var.policy_description, "Scoped IAM policy: ${local.policy_full_name}")
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Proibido combinar Action \"*\" com Resource \"*\" em uma mesma statement."
    }
  }
}
