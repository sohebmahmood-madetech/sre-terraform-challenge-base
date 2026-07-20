# CHANGE LOG:
# - Created: 2026-07-20
# - Purpose: Input variables for assets_bucket module

variable "project_name" {
  description = "Project name used in S3 bucket naming convention (lowercase, alphanumeric, hyphens only)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must be lowercase, alphanumeric, and may contain hyphens."
  }
}
