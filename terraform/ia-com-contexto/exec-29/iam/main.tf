locals {
  policy_name_full = "${var.environment}-${var.system}-iam-${var.policy_name}"

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
    sid       = "AllowedActions"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_name_full
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A statement da policy nao pode combinar Action \"*\" com Resource \"*\"."
    }

    precondition {
      condition     = !contains(var.allowed_actions, "*") || length(var.allowed_actions) == 1
      error_message = "Quando \"*\" for utilizado em allowed_actions, ele deve ser o unico item da lista."
    }

    precondition {
      condition     = !contains(var.allowed_resources, "*") || length(var.allowed_resources) == 1
      error_message = "Quando \"*\" for utilizado em allowed_resources, ele deve ser o unico item da lista."
    }
  }
}
