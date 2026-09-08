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

output "security_group_tags" {
  description = "Tags efetivas aplicadas ao Security Group."
  value       = aws_security_group.this.tags_all
}

output "ingress_rules_input" {
  description = "Regras de ingress fornecidas como entrada."
  value       = var.ingress_rules
}

output "egress_rules_input" {
  description = "Regras de egress fornecidas como entrada."
  value       = var.egress_rules
}
