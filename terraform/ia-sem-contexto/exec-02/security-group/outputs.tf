output "id" {
  description = "ID do Security Group criado."
  value       = aws_security_group.this.id
}

output "arn" {
  description = "ARN do Security Group criado."
  value       = aws_security_group.this.arn
}

output "vpc_id" {
  description = "ID da VPC associada ao Security Group."
  value       = aws_security_group.this.vpc_id
}

output "name" {
  description = "Nome efetivo do Security Group criado."
  value       = aws_security_group.this.name
}
