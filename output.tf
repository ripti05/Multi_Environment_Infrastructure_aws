output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.app[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = aws_instance.app[*].public_ip
}

output "instance_public_dns" {
  description = "Public DNS names of EC2 instances"
  value       = aws_instance.app[*].public_dns
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.app.id
}