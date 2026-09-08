output "iam_policy_arn" {
  description = "ARN da IAM Managed Policy."
  value       = aws_iam_policy.this.arn
}

output "iam_policy_id" {
  description = "ID da IAM Managed Policy (geralmente o ARN)."
  value       = aws_iam_policy.this.id
}

output "iam_policy_name" {
  description = "Nome da IAM Managed Policy."
  value       = aws_iam_policy.this.name
}

output "iam_policy_path" {
  description = "Path da IAM Managed Policy."
  value       = aws_iam_policy.this.path
}

output "iam_policy_document_json" {
  description = "Documento JSON efetivo da policy."
  value       = aws_iam_policy.this.policy
}
