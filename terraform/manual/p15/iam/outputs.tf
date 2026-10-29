output "iam_role_name" {
  description = "Nome da IAM role"
  value       = aws_iam_role.app.name
}

output "iam_role_arn" {
  description = "ARN da IAM role"
  value       = aws_iam_role.app.arn
}

output "iam_policy_arn" {
  description = "ARN da policy"
  value       = aws_iam_policy.app_s3.arn
}

output "instance_profile_name" {
  description = "Instance profile para usar em uma EC2"
  value       = aws_iam_instance_profile.app.name
}
