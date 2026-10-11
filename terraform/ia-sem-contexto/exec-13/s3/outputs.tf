output "bucket_id" {
  description = "Nome (ID) do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3 criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Nome de dominio do bucket S3."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Nome de dominio regional do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status configurado para o versionamento do bucket (Enabled ou Suspended)."
  value       = var.versioning_enabled ? "Enabled" : "Suspended"
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia server-side aplicado ao bucket."
  value       = var.kms_key_arn != null ? "aws:kms" : "AES256"
}
