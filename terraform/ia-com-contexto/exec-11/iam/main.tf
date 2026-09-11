provider "aws" {
  region = var.region
}

locals {
  resource = "iam"

  # Nome padronizado: <ambiente>-<sistema>-<recurso>-<finalidade>
  name = "${var.environment}-${var.system}-${local.resource}-${var.policy_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(var.additional_tags, local.mandatory_tags)
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowSpecificActionsOnSpecificResources"
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.name
  description = var.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    # Segurança: proíbe uma statement com Action="*" e Resource="*"
    precondition {
      condition     = !(length(var.allowed_actions) == 1 && var.allowed_actions[0] == "*" && length(var.allowed_resources) == 1 && var.allowed_resources[0] == "*")
      error_message = "Combinação proibida: 'Action'='*' com 'Resource'='*' na mesma policy."
    }
  }
}
