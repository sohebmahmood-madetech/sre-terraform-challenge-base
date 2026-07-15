variable "project_name" {
  description = "Short name used to prefix resource names."
  type        = string
  default     = "sre-challenge"
}

variable "environment" {
  description = "Deployment environment identifier (e.g. playground, dev)."
  type        = string
  default     = "playground"
}

variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.42.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.42.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for the web server."
  type        = string
  default     = "t3.micro"
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed to reach the web server over HTTP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "web_message" {
  description = "Message displayed on the landing page for this deployment."
  type        = string
  default     = "Provisioned with Terraform."
}
