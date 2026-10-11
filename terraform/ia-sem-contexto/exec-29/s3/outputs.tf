output "bucket_id" {
  description = "Nome (ID) do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3 criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Nome de dominio regional do bucket S3, util para configuracao de outros recursos (ex.: CloudFront)."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_status" {
  description = "Status atual do versionamento do bucket (Enabled ou Suspended)."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "encryption_algorithm" {
  description = "Algoritmo de criptografia server-side configurado no bucket."
  value       = var.sse_algorithm
}
