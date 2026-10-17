output "policy_name" {
  description = "Nome da policy IAM criada."
  value       = aws_iam_policy.workload.name
}

output "policy_arn" {
  description = "ARN da policy IAM criada."
  value       = aws_iam_policy.workload.arn
}

output "policy_id" {
  description = "ID exclusivo da policy IAM criada."
  value       = aws_iam_policy.workload.policy_id
}

output "role_name" {
  description = "Nome da role IAM criada."
  value       = aws_iam_role.workload.name
}

output "role_arn" {
  description = "ARN da role IAM criada."
  value       = aws_iam_role.workload.arn
}
