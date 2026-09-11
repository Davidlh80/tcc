locals {
  # Nome do recurso seguindo o padrão <ambiente>-<sistema>-<recurso>-<finalidade>
  resource_name = "${var.environment}-${var.system}-s3-${var.purpose}"

  mandatory_tags = {
    Project     = "tcc-iac-ia"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "devops"
    CostCenter  = "academic-research"
  }

  # additional_tags não pode sobrescrever as tags mandatórias
  common_tags = merge(var.additional_tags, local.mandatory_tags)
}

resource "aws_s3_bucket" "this" {
  bucket        = local.resource_name
  force_destroy = var.force_destroy

  tags = local.common_tags
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
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_key_id : null
    }
  }

  lifecycle {
    precondition {
      condition     = var.sse_algorithm != "aws:kms" || (var.sse_algorithm == "aws:kms" && length(trim(var.kms_key_id)) > 0)
      error_message = "kms_key_id deve ser informado quando sse_algorithm for 'aws:kms'."
    }
  }
}

data "aws_iam_policy_document" "https_only" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
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
  policy = data.aws_iam_policy_document.https_only.json
}
