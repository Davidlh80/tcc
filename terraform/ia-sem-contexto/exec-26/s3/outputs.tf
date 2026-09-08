output "bucket_name" {
  description = "Nome do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "region" {
  description = "Regiao AWS utilizada."
  value       = data.aws_region.current.name
}
