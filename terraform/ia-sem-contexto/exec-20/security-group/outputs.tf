output "security_group_id" {
  description = "ID of the created Security Group."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN of the created Security Group."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "Name of the created Security Group."
  value       = aws_security_group.this.name
}

output "security_group_vpc_id" {
  description = "VPC ID associated with the Security Group."
  value       = aws_security_group.this.vpc_id
}

output "ingress_rules_count" {
  description = "Number of ingress rules configured."
  value       = length(local.ingress_rules)
}

output "egress_rules_count" {
  description = "Number of egress rules configured."
  value       = var.allow_all_egress ? length(var.egress_cidr_blocks) + length(var.egress_ipv6_cidr_blocks) : 0
}
