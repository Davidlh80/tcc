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

  tags = merge(var.additional_tags, local.mandatory_tags)
}

data "aws_iam_policy_document" "allow" {
  statement {
    sid     = "AllowExplicitActionsOnExplicitResources"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.allow.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Proibido combinar Action \"*\" com Resource \"*\" na mesma policy statement."
    }
    precondition {
      condition     = length(var.allowed_actions) > 0 && length(var.allowed_resources) > 0
      error_message = "As variáveis allowed_actions e allowed_resources devem conter ao menos um item."
    }
  }
}
