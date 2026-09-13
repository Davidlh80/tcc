locals {
  name_prefix = "${var.environment}-${var.system}-iam-${var.policy_name}"

  policy_has_wildcard_action   = contains(var.allowed_actions, "*")
  policy_has_wildcard_resource = contains(var.allowed_resources, "*")

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
}

provider "aws" {
  region = var.region
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
  name        = local.name_prefix
  description = "Policy de menor privilegio para ${var.system} (${var.environment}) - finalidade: ${var.policy_name}"
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(local.policy_has_wildcard_action && local.policy_has_wildcard_resource)
      error_message = "Nao e permitido combinar Action = \"*\" com Resource = \"*\" na mesma statement. Restrinja allowed_actions ou allowed_resources."
    }
  }
}
