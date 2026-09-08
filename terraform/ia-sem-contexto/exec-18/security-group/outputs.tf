output "security_group_id" {
  description = "ID do Security Group."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN do Security Group."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Nome do Security Group."
  value       = aws_security_group.this.name
}

output "security_group_vpc_id" {
  description = "ID da VPC associada ao Security Group."
  value       = aws_security_group.this.vpc_id
}

output "ingress_rules_count" {
  description = "Quantidade de regras de entrada aplicadas."
  value       = length(aws_security_group.this.ingress)
}

output "egress_rules_count" {
  description = "Quantidade de regras de saída aplicadas."
  value       = length(aws_security_group.this.egress)
}
