# CHANGE LOG:
# - 2026-07-20: Added IAM role and instance profile outputs

output "instance_id" {
  description = "ID of the web server instance."
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address of the web server."
  value       = aws_instance.web.public_ip
}

output "security_group_id" {
  description = "ID of the web server security group."
  value       = aws_security_group.web.id
}

output "iam_role_name" {
  description = "Name of the IAM role attached to the web server instance."
  value       = aws_iam_role.web_server.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the web server instance."
  value       = aws_iam_role.web_server.arn
}

output "instance_profile_name" {
  description = "Name of the instance profile attached to the EC2 instance."
  value       = aws_iam_instance_profile.web_server.name
}
