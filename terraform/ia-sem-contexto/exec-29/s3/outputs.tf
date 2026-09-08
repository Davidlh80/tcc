output "bucket_id" {
  description = "ID do bucket (igual ao nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_name" {
  description = "Nome do bucket."
  value       = aws_s3_bucket.this.bucket
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

output "encryption_algorithm" {
  description = "Algoritmo de criptografia do bucket."
  value       = var.sse_algorithm
}

output "bucket_policy_id" {
  description = "ID da bucket policy (se anexada)."
  value       = var.attach_bucket_policy ? aws_s3_bucket_policy.this[0].id : null
}
