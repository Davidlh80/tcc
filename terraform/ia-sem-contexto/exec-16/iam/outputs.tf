output "policy_arn" {
  description = "ARN of the IAM Policy."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID of the IAM Policy."
  value       = aws_iam_policy.this.id
}

output "policy_name" {
  description = "Name of the IAM Policy."
  value       = aws_iam_policy.this.name
}

output "policy_path" {
  description = "Path of the IAM Policy."
  value       = aws_iam_policy.this.path
}

output "policy_default_version_id" {
  description = "Default version ID of the IAM Policy."
  value       = aws_iam_policy.this.default_version_id
}

output "policy_document_json" {
  description = "Rendered IAM policy document (JSON)."
  value       = data.aws_iam_policy_document.this.json
}
