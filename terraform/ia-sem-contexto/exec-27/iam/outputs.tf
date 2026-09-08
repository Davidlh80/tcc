output "iam_policy_arn" {
  description = "The ARN of the IAM policy."
  value       = aws_iam_policy.this.arn
}

output "iam_policy_id" {
  description = "The stable unique identifier for the IAM policy."
  value       = aws_iam_policy.this.policy_id
}

output "iam_policy_name" {
  description = "The name of the IAM policy."
  value       = aws_iam_policy.this.name
}

output "iam_policy_path" {
  description = "The path of the IAM policy."
  value       = aws_iam_policy.this.path
}

output "iam_policy_default_version_id" {
  description = "The default version ID of the IAM policy."
  value       = aws_iam_policy.this.default_version_id
}

output "iam_policy_document_json" {
  description = "The rendered IAM policy document JSON."
  value       = data.aws_iam_policy_document.this.json
}
