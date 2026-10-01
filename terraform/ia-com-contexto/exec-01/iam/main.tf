terraform {
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

locals {
  name_prefix = "${var.environment}-${var.system}-iam-${var.policy_name}"
  role_name   = "${local.name_prefix}-role"

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

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AllowAssumeRoleFromTrustedPrincipal"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AllowConfiguredActionsOnConfiguredResources"
    effect    = "Allow"
    actions   = var.actions
    resources = var.resources
  }
}

resource "aws_iam_policy" "this" {
  name        = local.name_prefix
  description = "Policy gerenciada por Terraform para ${local.name_prefix}, com permissoes restritas as actions e resources informados via variavel."
  policy      = data.aws_iam_policy_document.this.json
  tags        = local.tags

  lifecycle {
    precondition {
      condition     = !(contains(var.actions, "*") && contains(var.resources, "*"))
      error_message = "A policy nao pode combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.role_name
  description          = "Role gerenciada por Terraform, assumida exclusivamente pelo principal configurado em trusted_principal_arn."
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600
  tags                 = local.tags

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*"
      error_message = "trusted_principal_arn nao pode ser \"*\". E obrigatorio restringir a trust policy a um principal especifico."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
