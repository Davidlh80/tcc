provider "aws" {
  region = var.region
}

locals {
  # Nome do bucket conforme padrão organizacional: <ambiente>-<sistema>-<recurso>-<finalidade>(-<sufixo>)
  bucket_name = join(
    "-",
    compact([
      var.environment,
      var.system,
      "s3",
      var.purpose,
      var.name_suffix != "" ? var.name_suffix : null
    ])
  )

  # Tags obrigatórias + opcionais
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

  deny_insecure_transport_statement = {
    Sid       = "DenyInsecureTransport"
    Effect    = "Deny"
    Principal = "*"
    Action    = "s3:*"
    Resource = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    Condition = {
      Bool = {
        "aws:SecureTransport" = "false"
      }
    }
  }

  deny_incorrect_encryption_statement = {
    Sid       = "DenyIncorrectEncryption"
    Effect    = "Deny"
    Principal = "*"
    Action    = ["s3:PutObject"]
    Resource  = ["${aws_s3_bucket.this.arn}/*"]
    Condition = var.sse_algorithm == "AES256" ? {
      StringNotEquals = {
        "s3:x-amz-server-side-encryption" = "AES256"
      }
    } : {
      StringNotEquals = merge(
        {
          "s3:x-amz-server-side-encryption" = "aws:kms"
        },
        var.kms_key_arn != "" ? {
          "s3:x-amz-server-side-encryption-aws-kms-key-id" = var.kms_key_arn
        } : {}
      )
    }
  }

  bucket_policy_document = {
    Version   = "2012-10-17"
    Statement = [
      local.deny_insecure_transport_statement,
      local.deny_incorrect_encryption_statement
    ]
  }
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = local.tags
}

# Propriedade de objetos: desabilita ACLs (recomendação de segurança)
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Bloqueio de acesso público (todas as flags = true)
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versionamento configurável
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Criptografia server-side por padrão (SSE-S3 ou SSE-KMS)
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = var.sse_algorithm == "aws:kms" ? true : false

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_key_arn : null
    }
  }
}

# Política para reforçar HTTPS e headers de criptografia
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode(local.bucket_policy_document)
}
