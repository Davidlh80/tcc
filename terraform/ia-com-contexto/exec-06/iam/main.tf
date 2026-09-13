terraform {
  required_version = ">= 1.5.0"
}

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
    sid       = "AllowConfiguredAccess"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Statements nao podem combinar Action \"*\" com Resource \"*\". Restrinja allowed_actions ou allowed_resources."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.name
  description = "Policy gerenciada via Terraform para a finalidade '${var.policy_name}' do sistema ${var.system} (${var.environment})."
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags
}
