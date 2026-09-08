output "iam_policy_arn" {
  description = "ARN of the managed IAM policy."
  value       = aws_iam_policy.this.arn
}

output "iam_policy_name" {
  description = "Name of the managed IAM policy."
  value       = aws_iam_policy.this.name
}

output "iam_policy_id" {
  description = "ID of the managed IAM policy."
  value       = aws_iam_policy.this.id
}

output "iam_policy_path" {
  description = "Path of the managed IAM policy."
  value       = aws_iam_policy.this.path
}

output "iam_policy_document" {
  description = "Final JSON policy document applied to the IAM policy."
  value       = jsondecode(aws_iam_policy.this.policy)
}

output "iam_policy_tags" {
  description = "Tags applied to the IAM policy."
  value       = aws_iam_policy.this.tags
}
