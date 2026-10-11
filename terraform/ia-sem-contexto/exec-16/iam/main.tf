terraform {
  # Backend configurado externamente (nao usar backend remoto neste blueprint).
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

# Trust policy (assume role policy) restrita a principal(is) configuravel(is).
# Nunca permite "*" como principal (validado em variables.tf).
data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowConfiguredPrincipalToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_principal_arns
    }

    dynamic "condition" {
      for_each = var.assume_role_external_id == null ? [] : [var.assume_role_external_id]
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [condition.value]
      }
    }
  }
}

# Policy de permissoes da role: escopo minimo (sem acoes administrativas e sem
# recursos "*" amplos). Exemplo padrao: escrita de logs no CloudWatch Logs,
# restrita a conta/regiao atuais e a um prefixo de log group configuravel.
data "aws_iam_policy_document" "role_permissions" {
  statement {
    sid    = "AllowCloudWatchLogsWriteScoped"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name_prefix}*",
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name_prefix}*:*",
    ]
  }
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  description          = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  policy      = data.aws_iam_policy_document.role_permissions.json

  tags = var.tags
}

# Garante que a policy esteja sempre anexada a role (nenhum principal fica
# sem policy associada e a policy nunca fica "solta").
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
