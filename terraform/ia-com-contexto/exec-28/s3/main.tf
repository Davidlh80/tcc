locals {
  # Nome do bucket seguindo o padrão: <ambiente>-<sistema>-<recurso>-<finalidade>
  bucket_name = "${var.environment}-${var.system}-s3-${var.purpose}"
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name

  # Validações adicionais de segurança e conformidade
  lifecycle {
    precondition {
      condition     = length(local.bucket_name) <= 63
      error_message = "O nome do bucket S3 deve ter no máximo 63 caracteres."
    }
    precondition {
      condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", local.bucket_name))
      error_message = "O nome do bucket S3 deve conter apenas letras minúsculas, números, pontos e hifens, começando e terminando com alfanumérico."
    }
  }

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

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_status
  }
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.deny_insecure_transport.json
}
