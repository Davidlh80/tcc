output "security_group_id" {
  description = "ID do Security Group."
  value       = aws_security_group.workload.id
}

output "security_group_arn" {
  description = "ARN do Security Group."
  value       = aws_security_group.workload.arn
}

output "security_group_name" {
  description = "Nome do Security Group."
  value       = aws_security_group.workload.name
}
