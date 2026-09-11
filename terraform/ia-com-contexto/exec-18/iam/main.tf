provider "aws" {
  region = var.region
}

locals {
  # Nome completo seguindo o padrão: <ambiente>-<sistema>-<recurso>-<finalidade>
  policy_full_name = format("%s-%s-iam-%s", var.environment, var.system, var.policy_name)

  # Tags obrigatórias com sobrescrição impedida (tags adicionais não substituem as obrigatórias)
  tags = merge(
    var.additional_tags,
    {
      Project     = "tcc-iac-ia"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "devops"
      CostCenter  = "academic-research"
    }
  )
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowConfiguredActions"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources

    dynamic "condition" {
      for_each = var.conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  # Controles de segurança organizacionais
  lifecycle {
    # Proíbe declaração que combine Action:"*" e Resource:"*"
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "A combinacao Action:\"*\" e Resource:\"*\" na mesma statement e proibida pela politica interna."
    }
  }
}
