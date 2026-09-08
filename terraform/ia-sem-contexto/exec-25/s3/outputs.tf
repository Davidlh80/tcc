output "bucket_id" {
  description = "ID do bucket (igual ao nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Domain name público do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_enabled" {
  description = "Indica se o versionamento está habilitado."
  value       = var.enable_versioning
}

output "bucket_region" {
  description = "Região configurada no provider."
  value       = var.region
}

output "logging_enabled" {
  description = "Indica se o Server Access Logging está habilitado."
  value       = length(aws_s3_bucket_logging.this) > 0
}
