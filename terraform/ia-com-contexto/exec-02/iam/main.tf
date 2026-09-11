locals {
  resource_type = "iam"
  name          = "${var.environment}-${var.system}-${local.resource_type}-${var.policy_name}"

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
    sid     = "AllowScopedActions"
    effect  = "Allow"
    actions = var.allowed_actions
    resources = var.allowed_resources

    dynamic "condition" {
      for_each = var.allowed_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = local.name
  path        = var.path
  description = var.description
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags
}
