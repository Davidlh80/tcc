output "policy_arn" {
  description = "ARN of the created IAM policy."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID of the created IAM policy."
  value       = aws_iam_policy.this.id
}

output "policy_name" {
  description = "Name of the created IAM policy."
  value       = aws_iam_policy.this.name
}

output "policy_document_json" {
  description = "Rendered JSON document of the IAM policy."
  value       = data.aws_iam_policy_document.this.json
}
