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
  description = "Domain name público do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status do versionamento (Enabled/Suspended)."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "sse_algorithm" {
  description = "Algoritmo de criptografia padrão do bucket."
  value       = var.sse_algorithm
}
