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
