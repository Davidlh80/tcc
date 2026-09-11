provider "aws" {
  region = var.region
}

locals {
  # Nome padronizado: <ambiente>-<sistema>-<recurso>-<finalidade>
  policy_full_name = "${lower(var.environment)}-${lower(var.system)}-iam-${lower(var.policy_name)}"

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
    sid     = "AllowActionsOnDeclaredResources"
    effect  = "Allow"
    actions = var.permitted_actions
    resources = var.permitted_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = coalesce(var.policy_description, "Custom IAM policy for ${var.environment}/${var.system}: ${var.policy_name}")
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(length(var.permitted_actions) == 1 && var.permitted_actions[0] == "*" && length(var.permitted_resources) == 1 && var.permitted_resources[0] == "*")
      error_message = "Proibido criar statement com Action \"*\" e Resource \"*\". Ajuste permitted_actions e/ou permitted_resources."
    }
  }
}
