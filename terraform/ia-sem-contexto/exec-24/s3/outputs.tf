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
  description = "DNS global do bucket."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "DNS regional do bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_region" {
  description = "Regiao AWS usada."
  value       = var.aws_region
}

output "versioning_status" {
  description = "Status de versionamento do bucket."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}

output "sse_algorithm" {
  description = "Algoritmo de criptografia do lado do servidor configurado."
  value       = var.sse_algorithm
}

output "kms_key_id" {
  description = "KMS Key ID/ARN utilizado (quando aws:kms)."
  value       = var.kms_key_id
}
