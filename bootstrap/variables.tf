variable "github_repository" {
  description = "GitHub repository allowed to assume the deploy role, in 'owner/repo' form."
  type        = string

  validation {
    condition     = can(regex("^[^/]+/[^/]+$", var.github_repository))
    error_message = "Must be in 'owner/repo' form, e.g. 'made-tech/sre-terraform-challenge'."
  }
}

variable "aws_region" {
  description = "AWS region for the state bucket."
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Prefix used for the deploy role, state bucket and the IAM resources the pipeline may manage."
  type        = string
  default     = "sre-challenge"
}
