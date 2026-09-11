locals {
  policy_resource_token = "iam"

  # Nome padronizado: <ambiente>-<sistema>-<recurso>-<finalidade>
  policy_full_name = lower(format("%s-%s-%s-%s", var.environment, var.system, local.policy_resource_token, var.policy_name))

  required_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  merged_tags = merge(local.required_tags, var.additional_tags)
}

data "aws_iam_policy_document" "allow" {
  statement {
    sid     = "AllowConfiguredActions"
    effect  = "Allow"
    actions = var.allowed_actions

    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.allow.json
  tags        = local.merged_tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Proibido combinar Action \"*\" com Resource \"*\" na mesma policy (bloqueio organizacional)."
    }
  }
}
