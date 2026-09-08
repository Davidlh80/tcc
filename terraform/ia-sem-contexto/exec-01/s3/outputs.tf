output "bucket_id" {
  description = "ID do bucket (igual ao nome)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "Nome do bucket."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_domain_name" {
  description = "Endpoint DNS global do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Endpoint DNS regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status do versionamento."
  value       = var.versioning_enabled ? "Enabled" : "Suspended"
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia configurado."
  value       = var.sse_algorithm
}
