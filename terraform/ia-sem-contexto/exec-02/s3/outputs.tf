output "bucket_name" {
  description = "Nome do bucket S3."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
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
  description = "Região AWS usada pelo provider."
  value       = var.region
}

output "versioning_enabled" {
  description = "Indica se o versionamento do bucket está habilitado."
  value       = var.versioning_enabled
}

output "sse_algorithm" {
  description = "Algoritmo de criptografia do bucket."
  value       = var.sse_algorithm
}

output "kms_key_arn" {
  description = "ARN da KMS Key usada (se aplicável). Null se não especificada."
  value       = local.kms_key_arn
}
