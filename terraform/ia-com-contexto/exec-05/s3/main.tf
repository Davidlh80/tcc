provider "aws" {
  region = var.aws_region
}

locals {
  # Nome seguindo o padrão: <ambiente>-<sistema>-<recurso>-<finalidade>
  base_name = lower("${var.environment}-${var.system}-s3-${var.purpose}")

  # Sanitização para atender às regras do S3 (somente [a-z0-9-], sem traços nas extremidades, até 63 chars)
  sanitized_base = regexreplace(
    regexreplace(
      regexreplace(local.base_name, "[^a-z0-9-]", "-"),
      "-{2,}",
      "-"
    ),
    "^-|-$",
    ""
  )

  trimmed_name = substr(local.sanitized_base, 0, 63)

  bucket_name = length(local.trimmed_name) >= 3 ? local.trimmed_name : "${local.trimmed_name}bkt"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  tags   = local.tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
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
  bucket     = aws_s3_bucket.this.id
  policy     = data.aws_iam_policy_document.deny_insecure_transport.json
  depends_on = [aws_s3_bucket_public_access_block.this, aws_s3_bucket_ownership_controls.this]
}
