output "policy_name" {
  value = aws_iam_policy.this.name
}

output "policy_arn" {
  value = aws_iam_policy.this.arn
}

output "policy_id" {
  value = aws_iam_policy.this.id
}

output "role_name" {
  value = aws_iam_role.this.name
}

output "role_arn" {
  value = aws_iam_role.this.arn
}
