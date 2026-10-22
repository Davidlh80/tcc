output "policy_name" {
  description = "Name of the IAM policy"
  value       = aws_iam_policy.template_policy.name
}

output "policy_arn" {
  description = "ARN of the IAM policy"
  value       = aws_iam_policy.template_policy.arn
}

output "policy_id" {
  description = "ID of the IAM policy"
  value       = aws_iam_policy.template_policy.policy_id
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.template_role.name
}

output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.template_role.arn
}
