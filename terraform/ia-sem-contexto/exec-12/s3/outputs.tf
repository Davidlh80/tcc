output "bucket_id" {
  description = "ID do bucket (nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Domain name do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Domain name regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status do versionamento do bucket."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "sse_algorithm" {
  description = "Algoritmo de criptografia aplicado por padrão."
  value       = var.sse_algorithm
}
