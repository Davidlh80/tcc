output "bucket_name" {
  description = "Nome do bucket S3 criado seguindo o padrão <environment>-<system>-s3-<purpose>."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "ID do bucket S3 (normalmente igual ao nome)."
  value       = aws_s3_bucket.this.id
}
