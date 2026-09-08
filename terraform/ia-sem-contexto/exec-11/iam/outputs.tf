output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Nome da IAM Policy criada."
  value       = aws_iam_policy.this.name
}

output "policy_id" {
  description = "ID da IAM Policy criada."
  value       = aws_iam_policy.this.id
}

output "policy_path" {
  description = "Path da IAM Policy criada."
  value       = aws_iam_policy.this.path
}

output "policy_document_json" {
  description = "Documento JSON final da policy."
  value       = data.aws_iam_policy_document.this.json
}

output "policy_tags_all" {
  description = "Tags efetivas da IAM Policy (inclui herdadas)."
  value       = aws_iam_policy.this.tags_all
}
