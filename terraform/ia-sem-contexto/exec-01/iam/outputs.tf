output "policy_id" {
  description = "ID da IAM Policy."
  value       = aws_iam_policy.this.id
}

output "policy_arn" {
  description = "ARN da IAM Policy."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome final da IAM Policy."
  value       = aws_iam_policy.this.name
}

output "policy_path" {
  description = "Path da IAM Policy."
  value       = aws_iam_policy.this.path
}

output "policy_default_version_id" {
  description = "ID da versao padrao da IAM Policy."
  value       = aws_iam_policy.this.default_version_id
}

output "policy_document_json" {
  description = "Documento JSON da policy gerado."
  value       = aws_iam_policy.this.policy
}
