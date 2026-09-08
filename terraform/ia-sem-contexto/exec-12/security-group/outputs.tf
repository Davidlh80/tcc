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
  description = "VPC ID associada ao Security Group."
  value       = aws_security_group.this.vpc_id
}

output "ingress_rules_count" {
  description = "Quantidade de regras de ingress configuradas."
  value       = length(var.ingress_rules)
}

output "egress_rules_count" {
  description = "Quantidade de regras de egress configuradas."
  value       = length(var.egress_rules)
}
