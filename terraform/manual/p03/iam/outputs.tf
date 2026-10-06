output "policy_name" {
  description = "Name of the IAM policy."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN of the IAM policy."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "Unique ID of the IAM policy."
  value       = aws_iam_policy.this.policy_id
}

output "role_name" {
  description = "Name of the IAM role."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "ARN of the IAM role."
  value       = aws_iam_role.this.arn
}
