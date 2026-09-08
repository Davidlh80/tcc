output "iam_policy_arn" {
  description = "The ARN of the IAM Policy."
  value       = aws_iam_policy.this.arn
}

output "iam_policy_id" {
  description = "The IAM Policy ID."
  value       = aws_iam_policy.this.id
}

output "iam_policy_name" {
  description = "The name of the IAM Policy."
  value       = aws_iam_policy.this.name
}

output "iam_policy_path" {
  description = "The path of the IAM Policy."
  value       = aws_iam_policy.this.path
}

output "iam_policy_document_json" {
  description = "The effective IAM Policy document JSON used to create the policy."
  value       = local.effective_policy_json
}
