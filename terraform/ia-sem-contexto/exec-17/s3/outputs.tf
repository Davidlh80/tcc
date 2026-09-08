output "bucket_name" {
  description = "Nome do bucket S3."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Domain name público do bucket S3."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "sse_algorithm" {
  description = "Algoritmo SSE configurado no bucket."
  value       = var.sse_algorithm
}

output "versioning_enabled" {
  description = "Indica se o versionamento está habilitado."
  value       = var.enable_versioning
}
