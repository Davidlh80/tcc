output "security_group_id" {
  description = "ID do Security Group criado."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN do Security Group criado."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Nome do Security Group criado."
  value       = aws_security_group.this.name
}

output "security_group_vpc_id" {
  description = "ID da VPC associada ao Security Group."
  value       = aws_security_group.this.vpc_id
}

output "ingress_rule_ids" {
  description = "IDs das regras de ingress criadas."
  value       = [for k, r in aws_vpc_security_group_ingress_rule.this : r.id]
}

output "egress_rule_ids" {
  description = "IDs das regras de egress criadas."
  value       = [for k, r in aws_vpc_security_group_egress_rule.this : r.id]
}
