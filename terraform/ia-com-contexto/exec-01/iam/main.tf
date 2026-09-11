provider "aws" {
  region = var.region
}

locals {
  # Nome do recurso seguindo o padrão organizacional: <ambiente>-<sistema>-<recurso>-<finalidade>
  resource_name = "${var.environment}-${var.system}-iam-${var.policy_name}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  # Tags finais: variáveis adicionais podem complementar, mas não sobrescrevem as obrigatórias
  tags = merge(var.additional_tags, local.mandatory_tags)
}

data "aws_iam_policy_document" "this" {
  statement {
    effect    = "Allow"
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Política inválida: é proibido combinar Action=\"*\" com Resource=\"*\" na mesma statement."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.resource_name
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Política inválida: é proibido combinar Action=\"*\" com Resource=\"*\" na mesma statement."
    }
  }
}
