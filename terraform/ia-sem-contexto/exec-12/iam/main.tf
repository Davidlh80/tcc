locals {
  common_tags = merge(
    {
      ManagedBy = "terraform"
    },
    var.tags
  )

  has_service_principals = length(var.trusted_service_principals) > 0
  has_account_principals  = length(var.trusted_account_principals) > 0

  contains_wildcard_action   = contains(var.policy_actions, "*")
  contains_wildcard_resource = contains(var.policy_resources, "*")
}

data "aws_iam_policy_document" "assume_role" {
  dynamic "statement" {
    for_each = local.has_service_principals ? [1] : []

    content {
      sid     = "TrustedServicePrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = var.trusted_service_principals
      }
    }
  }

  dynamic "statement" {
    for_each = local.has_account_principals ? [1] : []

    content {
      sid     = "TrustedAccountPrincipals"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = var.trusted_account_principals
      }

      dynamic "condition" {
        for_each = var.external_id != null ? [var.external_id] : []

        content {
          test     = "StringEquals"
          variable = "sts:ExternalId"
          values   = [condition.value]
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  path                  = var.path
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = var.force_detach_policies
  tags                  = local.common_tags

  lifecycle {
    precondition {
      condition     = local.has_service_principals || local.has_account_principals
      error_message = "Defina ao menos um principal confiavel em var.trusted_service_principals ou var.trusted_account_principals para o assume role policy."
    }
  }
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    sid       = "RolePermissions"
    effect    = var.policy_effect
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.role_policy.json
  tags        = local.common_tags

  lifecycle {
    precondition {
      condition     = var.allow_wildcard_actions || !local.contains_wildcard_action
      error_message = "Uso de \"*\" em policy_actions requer var.allow_wildcard_actions = true."
    }

    precondition {
      condition     = var.allow_wildcard_resources || !local.contains_wildcard_resource
      error_message = "Uso de \"*\" em policy_resources requer var.allow_wildcard_resources = true."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
