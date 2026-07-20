# CHANGE LOG:
# - Created: 2026-07-20
# - Purpose: Terraform version requirements for assets_bucket module

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
