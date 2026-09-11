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
}

data "aws_iam_policy_document" "allow" {
  statement {
    sid     = "AllowActionsOnDefinedResources"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.resource_name
  description = coalesce(var.policy_description, "IAM policy for ${var.system} (${var.environment}) - ${var.policy_name}")
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.allow.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Proibido combinar Action \"*\" com Resource \"*\" na mesma policy statement."
    }
  }
}
