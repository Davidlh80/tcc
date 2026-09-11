output "policy_name" {
  description = "Nome final da IAM Policy criada seguindo o padrao de nomenclatura organizacional."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID da IAM Policy criada."
  value       = aws_iam_policy.this.id
}
