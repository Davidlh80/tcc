output "bucket_id" {
  description = "Identificador (nome) do bucket S3 criado."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3 criado."
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Nome de dominio regional do bucket, util para configuracao de CloudFront ou outros servicos."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "account_id" {
  description = "ID da conta AWS proprietaria do bucket."
  value       = data.aws_caller_identity.current.account_id
}
