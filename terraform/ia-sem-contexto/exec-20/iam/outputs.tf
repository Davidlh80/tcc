output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID da IAM Policy criada."
  value       = aws_iam_policy.this.id
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "policy_document_json" {
  description = "Documento JSON da policy renderizado a partir dos statements informados."
  value       = data.aws_iam_policy_document.this.json
}
