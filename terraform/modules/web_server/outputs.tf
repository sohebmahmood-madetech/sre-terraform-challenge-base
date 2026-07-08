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
