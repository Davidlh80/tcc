provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    var.tags,
    {
      ManagedBy = "terraform"
    }
  )

  principal_configs = concat(
    length(var.assume_role_service_principals) > 0 ? [
      {
        type            = "Service"
        identifiers     = var.assume_role_service_principals
        use_external_id = false
      }
    ] : [],
    length(var.assume_role_account_principals) > 0 ? [
      {
        type            = "AWS"
        identifiers     = var.assume_role_account_principals
        use_external_id = var.external_id != null
      }
    ] : []
  )
}

data "aws_iam_policy_document" "assume_role" {
  dynamic "statement" {
    for_each = local.principal_configs
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = statement.value.type
        identifiers = statement.value.identifiers
      }

      dynamic "condition" {
        for_each = statement.value.use_external_id ? [var.external_id] : []
        content {
          test     = "StringEquals"
          variable = "sts:ExternalId"
          values   = [condition.value]
        }
      }
    }
  }
}

data "aws_iam_policy_document" "permissions" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  path                 = var.path
  description          = "Role gerenciada via Terraform com trust policy explicita e sem principals coringa."
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = true

  tags = merge(local.common_tags, { Name = var.role_name })

  lifecycle {
    precondition {
      condition     = length(local.principal_configs) > 0
      error_message = "Defina ao menos um principal (service ou account) em assume_role_service_principals ou assume_role_account_principals."
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = "Policy com permissoes explicitas, sem actions ou resources coringa, anexada a uma role especifica."
  policy      = data.aws_iam_policy_document.permissions.json

  tags = merge(local.common_tags, { Name = var.policy_name })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
