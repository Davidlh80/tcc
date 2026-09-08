output "security_group_id" {
  description = "The ID of the created Security Group."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "The ARN of the created Security Group."
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "The name of the created Security Group."
  value       = aws_security_group.this.name
}

output "security_group_vpc_id" {
  description = "The VPC ID associated with the Security Group."
  value       = aws_security_group.this.vpc_id
}

output "security_group_tags" {
  description = "All tags applied to the Security Group."
  value       = aws_security_group.this.tags_all
}
