output "role_name" {
  description = "Name of the created IAM role."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "ARN of the created IAM role."
  value       = aws_iam_role.this.arn
}

output "role_id" {
  description = "Unique ID of the created IAM role."
  value       = aws_iam_role.this.unique_id
}

output "policy_name" {
  description = "Name of the created IAM policy."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN of the created IAM policy."
  value       = aws_iam_policy.this.arn
}

output "policy_attachment_id" {
  description = "ID of the IAM role/policy attachment, confirming the policy is bound to the role."
  value       = aws_iam_role_policy_attachment.this.id
}
