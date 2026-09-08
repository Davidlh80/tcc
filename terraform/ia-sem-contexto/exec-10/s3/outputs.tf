output "bucket_name" {
  description = "Nome do bucket S3."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "ID do bucket (igual ao nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_domain_name" {
  description = "DNS global do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "DNS regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_enabled" {
  description = "Indica se o versionamento está habilitado."
  value       = var.enable_versioning
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia do bucket (SSE)."
  value       = var.kms_key_id == null ? "AES256" : "aws:kms"
}

output "access_logging_enabled" {
  description = "Indica se o Server Access Logging está habilitado."
  value       = var.enable_access_logging && var.access_log_bucket_name != null
}
