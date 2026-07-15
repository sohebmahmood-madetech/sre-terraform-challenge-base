output "web_server_public_ip" {
  description = "Public IP address of the web server."
  value       = module.web_server.public_ip
}

output "web_url" {
  description = "URL of the web server landing page."
  value       = "http://${module.web_server.public_ip}"
}

output "vpc_id" {
  description = "ID of the playground VPC."
  value       = aws_vpc.main.id
}

output "assets_bucket_name" {
  description = "Name of the private assets bucket."
  value       = module.assets_bucket.bucket_name
}
