output "bucket_id" {
  description = "ID do bucket S3."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "Nome do bucket S3."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_domain_name" {
  description = "Domain name do bucket (global)."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "region" {
  description = "Região AWS utilizada."
  value       = var.aws_region
}

output "versioning_enabled" {
  description = "Se o versionamento está habilitado."
  value       = var.enable_versioning
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia SSE padrão aplicado ao bucket."
  value       = var.sse_algorithm
}
