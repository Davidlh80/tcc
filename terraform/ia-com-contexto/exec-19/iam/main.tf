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
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowScopedActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.name
  description = var.policy_description != "" ? var.policy_description : "Policy ${local.name} gerenciada via Terraform."
  policy      = data.aws_iam_policy_document.this.json

  tags = local.tags
}
