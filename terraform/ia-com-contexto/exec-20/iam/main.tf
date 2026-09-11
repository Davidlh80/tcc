provider "aws" {
  region = var.region
}

locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  policy_description_resolved = coalesce(var.policy_description, "IAM policy for system ${var.system}")

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.required_tags, var.additional_tags)

  star_actions   = contains(var.allowed_actions, "*")
  star_resources = contains(var.allowed_resources, "*")
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
  name        = local.policy_full_name
  path        = var.policy_path
  description = local.policy_description_resolved
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(local.star_actions && local.star_resources)
      error_message = "Proibido criar statement com Action: \"*\" e Resource: \"*\" na mesma policy."
    }
  }
}
