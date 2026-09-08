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
  description = "VPC ID where the Security Group resides."
  value       = aws_security_group.this.vpc_id
}

output "ingress_rule_count" {
  description = "Number of ingress rules configured."
  value       = length(var.ingress_rules)
}

output "egress_rule_count" {
  description = "Number of egress rules configured (including default when enabled)."
  value       = length(local.computed_egress)
}
