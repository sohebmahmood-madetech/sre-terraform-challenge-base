# CHANGE LOG:
# - 2026-07-20: Added assets_bucket_arn and assets_bucket_name for S3 access

variable "name" {
  description = "Name prefix for the web server resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC to place the security group in."
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch the instance into."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed to reach the instance over HTTP."
  type        = list(string)
}

variable "environment" {
  description = "Environment name shown on the landing page."
  type        = string
}

variable "web_message" {
  description = "Message to display on the web page."
  type        = string
  default     = ""
}

variable "assets_bucket_arn" {
  description = "ARN of the S3 assets bucket for the EC2 instance to access."
  type        = string
}

variable "assets_bucket_name" {
  description = "Name of the S3 assets bucket for the EC2 instance to access."
  type        = string
}

variable "allowed_egress_cidrs" {
  description = "List of CIDR blocks that should be allowed for outbound traffic from the web server security group. Leave empty to avoid creating explicit egress rules."
  type        = list(string)
  default     = []
}
