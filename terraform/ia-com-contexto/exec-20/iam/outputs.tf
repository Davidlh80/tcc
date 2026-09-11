output "policy_name" {
  description = "Nome final da IAM Policy criada seguindo o padrão <environment>-<system>-iam-<policy_name>."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN da IAM Policy criada."
  value       = aws_iam_policy.this.arn
}

output "policy_id" {
  description = "ID exclusivo da IAM Policy criada."
  value       = aws_iam_policy.this.id
}
