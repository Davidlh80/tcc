output "bucket_id" {
  description = "Identificador (nome) do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3 criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Nome de dominio do bucket S3."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Nome de dominio regional do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_region" {
  description = "Regiao AWS onde o bucket S3 foi provisionado."
  value       = aws_s3_bucket.this.region
}
