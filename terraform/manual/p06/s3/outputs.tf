output "bucket_name" {
  description = "Nome do bucket de dados."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket de dados."
  value       = aws_s3_bucket.this.arn
}

output "log_bucket_name" {
  description = "Nome do bucket de logs."
  value       = aws_s3_bucket.logs.id
}

output "kms_key_arn" {
  description = "ARN da chave KMS usada na criptografia."
  value       = aws_kms_key.bucket.arn
}
