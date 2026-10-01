locals {
  policy_full_name = "${var.environment}-${var.system}-iam-${var.policy_name}-policy"
  role_full_name   = "${var.environment}-${var.system}-iam-${var.policy_name}-role"

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

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowTrustedPrincipalAssumeRole"
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
    actions   = var.allowed_actions
    resources = var.allowed_resources
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_full_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  lifecycle {
    precondition {
      condition     = var.trusted_principal_arn != "*"
      error_message = "trusted_principal_arn nao pode ser \"*\"; e obrigatorio informar um principal especifico."
    }
  }

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  name        = local.policy_full_name
  description = "Policy de minimo privilegio para o sistema ${var.system} no ambiente ${var.environment}, gerenciada via Terraform."
  policy      = data.aws_iam_policy_document.this.json

  lifecycle {
    precondition {
      condition     = !(contains(var.allowed_actions, "*") && contains(var.allowed_resources, "*"))
      error_message = "Nao e permitido combinar Action \"*\" com Resource \"*\" na mesma statement."
    }
  }

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
