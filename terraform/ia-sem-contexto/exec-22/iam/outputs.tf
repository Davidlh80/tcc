output "policy_arn" {
  description = "ARN of the IAM Policy."
  value       = aws_iam_policy.this.arn
}

output "policy_name" {
  description = "Name of the IAM Policy."
  value       = aws_iam_policy.this.name
}

output "policy_id" {
  description = "ID of the IAM Policy."
  value       = aws_iam_policy.this.id
}

output "policy_path" {
  description = "Path of the IAM Policy."
  value       = aws_iam_policy.this.path
}

output "policy_document_json" {
  description = "Final IAM policy document in JSON."
  value       = data.aws_iam_policy_document.this.json
}
