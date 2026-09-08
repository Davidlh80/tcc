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
  description = "VPC ID where the Security Group was created."
  value       = aws_security_group.this.vpc_id
}

output "ingress_rule_ids" {
  description = "List of ingress rule IDs created."
  value = flatten([
    [for r in aws_security_group_rule.ingress_cidr : r.id],
    [for r in aws_security_group_rule.ingress_sg : r.id],
    [for r in aws_security_group_rule.ingress_self : r.id]
  ])
}

output "egress_rule_ids" {
  description = "List of egress rule IDs created."
  value = flatten([
    [for r in aws_security_group_rule.egress_cidr : r.id],
    [for r in aws_security_group_rule.egress_sg : r.id],
    [for r in aws_security_group_rule.egress_self : r.id]
  ])
}
