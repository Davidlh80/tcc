output "policy_name" {
  description = "Nome da policy IAM criada."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN da policy IAM criada."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID único da policy IAM criada."
  value       = aws_iam_policy.this.id
}
