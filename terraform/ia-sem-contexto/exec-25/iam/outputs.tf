output "iam_policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "iam_policy_name" {
  description = "Nome da IAM Policy."
  value       = aws_iam_policy.this.name
}

output "iam_policy_id" {
  description = "ID da IAM Policy."
  value       = aws_iam_policy.this.id
}

output "iam_policy_document_json" {
  description = "Documento JSON final da policy."
  value       = data.aws_iam_policy_document.this.json
}
